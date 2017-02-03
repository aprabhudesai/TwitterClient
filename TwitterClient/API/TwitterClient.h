//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "User.h"
#import "Tweet.h"
#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *) sharedInstance;

#pragma mark - OAuth
- (void) loginWithCompletion: (void (^) (User *user, NSError *error))completion;
- (void) logout;
- (void) openURL: (NSURL *)url;
- (void) currentAccountWithSuccess: (void (^)(User *))success andFailure:(void (^)(NSError *))failure;

#pragma mark - Timeline APIs
- (void) homeTimelineFromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess: (void (^)(NSArray<Tweet *> *tweets))success andFailure:(void (^) (NSError *error)) failure;
- (void) mentionsTimelineFromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess: (void (^)(NSArray<Tweet *> *tweets))success andFailure:(void (^) (NSError *error)) failure;
- (void) userTimelineForUserScreenName:(NSString *)screenName fromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess: (void (^)(NSArray<Tweet *> *tweets))success andFailure:(void (^) (NSError *error)) failure;
- (void) favoriteListForUserScreenName:(NSString *)screenName fromTweetID:(NSString *)tweetId andNewData:(BOOL)isNew WithSuccess: (void (^)(NSArray<Tweet *> *tweets))success andFailure:(void (^) (NSError *error)) failure;

#pragma mark - Tweet APIs
- (void) postTweet: (NSString *)text onSuccess:(void (^)(NSDictionary *dictionary))success onFailure:(void (^)(NSError *error))failure;
- (void) reTweet: (NSString *)tweetId onSuccess:(void (^)(NSDictionary *dictionary))success onFailure:(void (^)(NSError *error))failure;
- (void) favoriteTweet: (NSString *)tweetId onSuccess:(void (^)(NSDictionary *dictionary))success onFailure:(void (^)(NSError *error))failure;
- (void) replyToTweet:(NSString *)tweetId withText:(NSString *)text onSuccess:(void (^)(NSDictionary *dictionary))success onFailure:(void (^)(NSError *error))failure;

@end
