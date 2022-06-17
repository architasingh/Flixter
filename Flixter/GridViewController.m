//
//  GridViewController.m
//  Flixter
//
//  Created by Archita Singh on 6/17/22.
//

#import "GridViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieCollectionViewCell.h"

@interface GridViewController () 
@end

@implementation GridViewController

// Gets info from API into created properties
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set datas source and delegate to self
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // Calls function that gets movie data
    [self fetchMovies];
    // Do any additional setup after loading the view.
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
            }
            else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               self.movies = dataDictionary[@"results"];
               
               // Reloads table view data
               [self.collectionView reloadData];
            }
    }];
    [task resume];
}

// Returns number of movies
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

// Returns cell for movie at the specified index
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];

         // Get the movie at the specified index in the movies array
         NSDictionary *moviesDict = self.movies[indexPath.row];

         // Get the movie poster URL as a string
         NSString *poster_path = moviesDict[@"poster_path"];
             poster_path = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString: poster_path];

         // Convert string to a URL
         NSURL *url = [NSURL URLWithString:poster_path];
         
         // Download and set the image using URL
         [cell.movieColImage setImageWithURL:url];
         
         return cell;
}

@end
