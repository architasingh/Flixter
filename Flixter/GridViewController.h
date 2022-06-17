//
//  GridViewController.h
//  Flixter
//
//  Created by Archita Singh on 6/17/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GridViewController : UICollectionViewController

// Stores movies in a property
@property (nonatomic, strong) NSArray *movies;

@end

NS_ASSUME_NONNULL_END
