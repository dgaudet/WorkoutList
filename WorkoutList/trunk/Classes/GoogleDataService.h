//
//  GDataService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleDataService.h"
#import "GDataDocs.h"

@interface GoogleDataService : NSObject {

}

+ (id)sharedInstance;
+ (NSDateFormatter *)docsDateFormatter;
- (GDataServiceGoogleDocs *)docsService;
- (void)fetchDocListWithdidFinishSelector:(SEL)selector forDelegate:(id)delegate;

@end
