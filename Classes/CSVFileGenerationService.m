//
//  CSVFileGenerationService.m
//  WorkoutList
//
//  Created by Dean on 2015-12-21.
//
//

#import "CSVFileGenerationService.h"

@interface CSVFileGenerationService (PrivateMethods)

- (void)removeTempFileAtURL:(NSURL *)fileURL error:(NSError *)error;

@end

@implementation CSVFileGenerationService

+ (instancetype)sharedInstance
{
    static CSVFileGenerationService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _tempFiles = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSURL *)createCSVFileWithFileName:(NSString *)fileName Body:(NSString *)csvBody error:(NSError *)error {
    NSString *tempFileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tempFileName]];
    
    NSData *csvData = [csvBody dataUsingEncoding:NSUTF8StringEncoding];
    [csvData writeToURL:fileURL options:NSDataWritingAtomic error:&error];
    
    [_tempFiles addObject:fileURL];
    
    return fileURL;
}

- (void)removeTempFilesWithError:(NSError *)error {
    for(NSURL *url in _tempFiles){
        if (url) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
                [self removeTempFileAtURL:url error:error];
            }
        }
    }
}

- (void)removeTempFileAtURL:(NSURL *)fileURL error:(NSError *)error {
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    if (error) {
        NSLog(@"File could not be removed");
    } else {
        NSLog(@"File deleted: %@", fileURL);
    }
}

@end
