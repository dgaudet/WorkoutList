//
//  GDataService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoogleDataService.h"
//#import "GDataDocs.h"
#import "UserService.h"

@implementation GoogleDataService

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    return master;
}

+ (NSDateFormatter *)docsDateFormatter {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	
	//No matter what the locale set on the device, we need to use us since that is the only locale
	//that google will be able to handle
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:usLocale];
	return formatter;
}

//- (GDataServiceGoogleDocs *)docsService {
//	
//	static GDataServiceGoogleDocs* service = nil;
//	
//	if (!service) {
//		service = [[GDataServiceGoogleDocs alloc] init];
//		[service setServiceShouldFollowNextLinks:YES];
//		[service setIsServiceRetryEnabled:YES];
//	}
//	
//	// update the username/password each time the service is requested
//	User *user = [[UserService sharedInstance] retrieveUser];
//	NSString *username = user.userName;
//	NSString *password = user.password;
//	
//	if ([username length] && [password length]) {
//		[service setUserCredentialsWithUsername:username password:password];
//	} else {
//		[service setUserCredentialsWithUsername:nil password:nil];
//	}
//	
//	return service;
//}

//- (void)fetchDocListWithdidFinishSelector:(SEL)selector forDelegate:(id)delegate {	
//	GDataServiceGoogleDocs *service = [self docsService];
//	GDataServiceTicket *ticket;
//	
//	// Fetching a feed gives us 25 responses by default.  We need to use
//	// the feed's "next" link to get any more responses.  If we want more than 25
//	// at a time, instead of calling fetchDocsFeedWithURL, we can create a
//	// GDataQueryDocs object, as shown here.
//	
//	NSURL *feedURL = [GDataServiceGoogleDocs docsFeedURL];
//	
//	GDataQueryDocs *query = [GDataQueryDocs documentQueryWithFeedURL:feedURL];
//	[query setMaxResults:1000];
//	[query setShouldShowFolders:YES];
//	
//	ticket = [service fetchFeedWithQuery:query delegate:delegate didFinishSelector:selector];	
//}

@end
