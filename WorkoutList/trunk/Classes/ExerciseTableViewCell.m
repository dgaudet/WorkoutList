//
//  EditingTableViewCell.m
//  WorkoutList
//
//  Created by Dean on 2013-10-11.
//
//

#import "ExerciseTableViewCell.h"
#import "Exercise.h"

@interface ExerciseTableViewCell (PrivateMethods)

- (CGRect)_nameViewFrame;
- (CGRect)_weightViewFrame;
- (CGRect)_repsViewFrame;

@end

@implementation ExerciseTableViewCell

@synthesize exercise = _exercise;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		nameLabel.contentMode = UIViewContentModeScaleAspectFit;
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLabel];
        
        weightlabel = [[UILabel alloc] initWithFrame:CGRectZero];
		weightlabel.contentMode = UIViewContentModeScaleAspectFit;
        weightlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        weightlabel.textColor = [UIColor redColor];
        [self.contentView addSubview:weightlabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [nameLabel setFrame:self._nameViewFrame];
    [weightlabel setFrame:self._weightViewFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define EDITING_INSET       0.0
#define NAME_LABEL_X        8.0
#define WEIGHT_LABEL_X      225.0

- (CGRect)_nameViewFrame {
    if (self.editing) {
        return CGRectMake(NAME_LABEL_X + EDITING_INSET, 0.0, WEIGHT_LABEL_X - NAME_LABEL_X - EDITING_INSET, 40.0);
    }
	else {
        return CGRectMake(NAME_LABEL_X, 0.0, WEIGHT_LABEL_X - NAME_LABEL_X, 40.0);
    }
}

- (CGRect)_weightViewFrame {
    if (self.editing) {
        return CGRectMake(WEIGHT_LABEL_X + EDITING_INSET, 2.0, 35.0 - EDITING_INSET, 40.0);
    }
	else {
        return CGRectMake(WEIGHT_LABEL_X, 2.0, 35.0, 40.0);
    }
}

- (void)setExercise:(Exercise *)newExercise {
    if (newExercise != _exercise) {
        [_exercise release];
        _exercise = [newExercise retain];
	}
	[nameLabel setText:_exercise.name];
    [weightlabel setText:_exercise.weight];
    [self.detailTextLabel setText:_exercise.reps];
}

- (void)dealloc {
    [nameLabel release];
    [weightlabel release];
    
    [super dealloc];
}

@end
