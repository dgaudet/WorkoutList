//
//  CenteredTableViewCell.m
//  WorkoutList
//
//  Created by Dean on 2016-07-16.
//
//

#import "CenteredTableViewCell.h"

@implementation CenteredTableViewCell

NSInteger *const MAIN_LABEL_TAG = 1;

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
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 2.0, 285.0, 40.0)];
        mainLabel.textAlignment = NSTextAlignmentCenter;
        mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        mainLabel.tag = MAIN_LABEL_TAG;
        
        [self.contentView addSubview:mainLabel];
        
        // Set up the cell...
    }
    
    return self;
}

- (UILabel *)mainLabel {
    return (UILabel *)[self.contentView viewWithTag:MAIN_LABEL_TAG];
}

@end
