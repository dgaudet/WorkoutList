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

+ (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;
- (CGFloat)heightForCellEditingMode:(BOOL)editingMode;
- (CGRect)_nameViewFrame;
- (CGRect)_weightViewFrame;
- (CGRect)_repsViewFrame;

@end

@implementation ExerciseTableViewCell

#define EDITING_INSET       30.0
#define NAME_LABEL_X        8.0
#define WEIGHT_LABEL_X      225.0
#define NAME_LABEL_WIDTH    WEIGHT_LABEL_X - NAME_LABEL_X
#define NAME_LABEL_WIDTH_EDITING    WEIGHT_LABEL_X - NAME_LABEL_X - EDITING_INSET
#define MINIMUM_HEIGHT      41.0

@synthesize exercise = _exercise;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		nameLabel.contentMode = UIViewContentModeScaleAspectFit;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.numberOfLines = 999;
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

#define MTVR_ROW_PADDING    6.0

+ (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 485.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGSize  size = rect.size;
    CGFloat height = size.height;
    if (height < MINIMUM_HEIGHT) {
        height = MINIMUM_HEIGHT;
    } else {
        height = height + MTVR_ROW_PADDING;
    }
    return height;
}

+ (CGFloat)heightForCellWithString:(NSString *)string editingMode:(BOOL)editingMode {
    CGFloat width = NAME_LABEL_WIDTH;
    if (editingMode) {
        width = NAME_LABEL_WIDTH_EDITING;
    }
    float height = [self heightForString:string withWidth:width withFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
    return height;
}

- (CGFloat)heightForCellEditingMode:(BOOL)editingMode {
    return [ExerciseTableViewCell heightForCellWithString:nameLabel.text editingMode:editingMode];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [nameLabel setFrame:self._nameViewFrame];
    [weightlabel setFrame:self._weightViewFrame];
    if (self.editing) {
        weightlabel.alpha = 0.0;
    } else {
        weightlabel.alpha = 1.0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGRect)_nameViewFrame {
    if (self.editing) {
        return CGRectMake(NAME_LABEL_X, 0.0, NAME_LABEL_WIDTH_EDITING, [self heightForCellEditingMode:YES]);
    }
	else {
        return CGRectMake(NAME_LABEL_X, 0.0, NAME_LABEL_WIDTH, [self heightForCellEditingMode:NO]);
    }
}

- (CGRect)_weightViewFrame {
    if (self.editing) {
        return CGRectMake(WEIGHT_LABEL_X - EDITING_INSET, 0.0, 35.0, [self heightForCellEditingMode:YES]);
    }
	else {
        return CGRectMake(WEIGHT_LABEL_X, 0.0, 35.0, [self heightForCellEditingMode:NO]);
    }
}

- (void)setExercise:(Exercise *)newExercise {
    if (newExercise != _exercise) {
        _exercise = newExercise;
	}
	[nameLabel setText:_exercise.name];
    [weightlabel setText:_exercise.weight];
    [self.detailTextLabel setText:_exercise.reps];
}


@end
