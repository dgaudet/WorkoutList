//
//  CSVFileGenerationService.h
//  WorkoutList
//
//  Created by Dean on 2015-12-21.
//
//

#import <Foundation/Foundation.h>

@interface CSVFileGenerationService : NSObject {
    NSMutableArray *_tempFiles;
}

+ (instancetype)sharedInstance;
- (NSURL *)createCSVFileWithFileName:(NSString *)fileName Body:(NSString *)csvBody error:(NSError *)error;
- (void)removeTempFilesWithError:(NSError *)error;

@end
