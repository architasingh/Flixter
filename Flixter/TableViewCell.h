//
//  TableViewCell.h
//  Flixter
//
//  Created by Archita Singh on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

// Outlets for all of the components in the tableView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDescr;


@end

NS_ASSUME_NONNULL_END
