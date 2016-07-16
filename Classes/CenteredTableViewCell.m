//
//  CenteredTableViewCell.m
//  WorkoutList
//
//  Created by Dean on 2016-07-16.
//
//

#import "CenteredTableViewCell.h"

@implementation CenteredTableViewCell

NSInteger *const TOP_LABEL_TAG = 1;
NSInteger *const BOTTOM_LABEL_TAG = 2;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 2.0, 285.0, 17.0)];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        topLabel.textColor = [UIColor blackColor];
        topLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        topLabel.tag = TOP_LABEL_TAG;
        
        [self.contentView addSubview:topLabel];

        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 32.0, 285.0, 8.0)];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        bottomLabel.textColor = [UIColor blackColor];
        bottomLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        bottomLabel.tag = BOTTOM_LABEL_TAG;
        
        [self.contentView addSubview:bottomLabel];
    }
    
    return self;
}

- (UILabel *)topLabel {
    return (UILabel *)[self.contentView viewWithTag:TOP_LABEL_TAG];
}

- (UILabel *)bottomLabel {
    return (UILabel *)[self.contentView viewWithTag:BOTTOM_LABEL_TAG];
}

+ (CGFloat)heightForCell {
    return 60;
}

@end
