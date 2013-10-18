//
//  EditingTableViewCell.h
//  WorkoutList
//
//  Created by Dean on 2013-10-11.
//
//

#import <UIKit/UIKit.h>
@class Exercise;

@interface ExerciseTableViewCell : UITableViewCell {
    Exercise *_exercise;
    
    UILabel *nameLabel;
    UILabel *weightlabel;
}

@property (nonatomic, retain) Exercise *exercise;

+ (CGFloat)heightForCellWithString:(NSString *)string editingMode:(BOOL)editingMode;

@end
