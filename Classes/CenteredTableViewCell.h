//
//  CenteredTableViewCell.h
//  WorkoutList
//
//  Created by Dean on 2016-07-16.
//
//

#import <UIKit/UIKit.h>

@interface CenteredTableViewCell : UITableViewCell

+ (CGFloat)heightForCell;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (UILabel *)topLabel;
- (UILabel *)bottomLabel;

@end
