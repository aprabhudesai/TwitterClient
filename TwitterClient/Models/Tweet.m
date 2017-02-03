//
//  Tweet.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary: (NSDictionary *) dictionary {
  self = [super init];
  
  if (self) {
    
//    NSLog(@"------- START --------");
//    NSLog(@"Tweet: %@", dictionary);
//    NSLog(@"------- END --------");
    
    self.tweetId = dictionary[@"id_str"];
    self.text = dictionary[@"text"];
    self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
    self.retweetCount = dictionary[@"retweet_count"];
    self.favoriteCount = dictionary[@"favorite_count"];
    
    NSString *createdAtString = dictionary[@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    
    self.createdAt = [formatter dateFromString:createdAtString];
    self.hasRetweetes = dictionary[@"retweeted_status"] ? YES : NO;

    if (self.hasRetweetes) {
      NSDictionary *retweetedStatus = dictionary[@"retweeted_status"];
      self.retweetUser = [[User alloc] initWithDictionary:retweetedStatus[@"user"]];
    }

    NSNumber *retweeted = dictionary[@"retweeted"];
    if ([retweeted integerValue] == 1) {
      self.isRetweeted = YES;
    }

    NSNumber *favorited = dictionary[@"favorited"];
    if ([favorited integerValue] == 1) {
      self.isFavorited = YES;
    }
  }
  return self;
}

+ (NSArray *) tweetsWithArray: (NSArray *) tweetsArray {
  NSMutableArray *tweets = [NSMutableArray array];
  
  for (NSDictionary *dictionary in tweetsArray) {
    [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
  }
  
  return tweets;
}

@end
