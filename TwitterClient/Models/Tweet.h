//
//  Tweet.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (strong, nonatomic) NSString *tweetId;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) User *user;
@property BOOL hasRetweetes;
@property (strong, nonatomic) User *retweetUser;
@property (strong, nonatomic) NSNumber *retweetCount;
@property (strong, nonatomic) NSNumber *favoriteCount;
@property BOOL isFavorited;
@property BOOL isRetweeted;

- (id) initWithDictionary: (NSDictionary *) dictionary;
+ (NSArray *) tweetsWithArray: (NSArray *) tweetsArray;

@end
