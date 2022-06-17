//
//  MovieViewController.m
//  Flixter
//
//  Created by Archita Singh on 6/15/22.
//

#import "MovieViewController.h"
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorMovie;

@end

@implementation MovieViewController

// Gets info from API into created properties
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Start the activity indicator
    [self.activityIndicatorMovie startAnimating];
    
    [self fetchMovies];
    
    // Refreshes view’s contents
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 280;
}

// Grabs movies using API url and generated key
// Checks for errors in grabbing movies
- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=69c6ec93cca90a67e18737d2d5ef5d6d"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               // Create alert with title and description
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies" message:@"The internet connection appears to be offline" preferredStyle:UIAlertControllerStyleAlert];

               // Create button to make alert go away
               UIAlertAction *try = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [self fetchMovies];
                                   }];
               
               // Give button functionality
               [alert addAction:try];
               
               // Present alert on screen
               [self presentViewController:alert animated:YES completion:nil];
               
           }
           else {
               [self.activityIndicatorMovie stopAnimating];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               self.movies = dataDictionary[@"results"];
               // TODO: Reload your table view data
               [self.tableView reloadData];
           }
   }];
[task resume];
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    // Create NSURL and NSURLRequest
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=69c6ec93cca90a67e18737d2d5ef5d6d"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:nil
                                                        delegateQueue:[NSOperationQueue mainQueue]];
       session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
   
       NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
   
          // ... Use the new data to update the data source ...

          // Reload the tableView now that there is new data
           [self.tableView reloadData];

          // Tell the refreshControl to stop spinning
           [refreshControl endRefreshing];

       }];
   
       [task resume];
}

#pragma mark - Navigation

// Creates segue to DetailsViewController and passes over selected movie
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
     NSDictionary *movie = self.movies[indexPath.row];
     DetailsViewController *detailVC = [segue destinationViewController];
     detailVC.movie = movie;
}
 
// Load poster image and labels for the movie info for each cell
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    cell.movieTitle.text = self.movies[indexPath.row][@"title"];
    cell.movieDescr.text = self.movies[indexPath.row][@"overview"];
    
    // Formatting for labels
    cell.movieTitle.numberOfLines = 0;
    cell.movieDescr.numberOfLines = 0;

    // Get the movie at the specified index in the movies array
    NSDictionary *moviesDict = self.movies[indexPath.row];
    
    // Check if image exists
    if ([moviesDict[@"poster_path"] isKindOfClass:[NSString class]]) {
        
        // Get the movie at the specified index in the movies array
        NSDictionary *moviesDict = self.movies[indexPath.row];

        // Get the movie poster URL as a string
        NSString *poster_path = moviesDict[@"poster_path"];
            poster_path = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString: poster_path];

        // Convert string to a URL
        NSURL *url = [NSURL URLWithString:poster_path];
        
        // Download and set the image using URL
        [cell.image setImageWithURL:url];
     }
     else {
         cell.image.image = nil;
    }
    
    return cell;
}

// Returns number of movies
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

@end
