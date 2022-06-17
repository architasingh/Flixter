//
//  DetailsViewController.m
//  Flixter
//
//  Created by Archita Singh on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TableViewCell.h"

@interface DetailsViewController ()

// Outlets for all of the components in the DetailsScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *DetailsScrollView;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieDescrFull;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *relDat;

@end

@implementation DetailsViewController

// Gets info from API into created properties
- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieName.text = self.movie[@"title"];
    self.movieDescrFull.text = self.movie[@"overview"];
    
    NSString *ratingVal = [NSString stringWithFormat: @"%@", self.movie[@"vote_average"]];
    
    NSString *ratingFull  = [@"Rating: " stringByAppendingString: ratingVal];
    self.rating.text = ratingFull;
    
    NSString *relDateInfo = [NSString stringWithFormat: @"%@", self.movie[@"release_date"]];
    
    NSString *relDateFull  = [@"Release Date: " stringByAppendingString: relDateInfo];
    self.relDat.text = relDateFull;
    
    self.movieName.numberOfLines = 0;
    self.movieDescrFull.numberOfLines = 0;

    // Get the movie poster URL as a string
    NSString *poster_path = self.movie[@"poster_path"];
        poster_path = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString: poster_path];
    
    // Convert string to a URL
    NSURL *url = [NSURL URLWithString:poster_path];
    
    // Download and set the image using URL
    [self.movieImage setImageWithURL:url];
}

@end
