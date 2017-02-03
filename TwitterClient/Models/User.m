//
//  User.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "User.h"

#define NAME_KEY @"name"
#define SCREEN_NAME_KEY @"screenName"
#define PROFILE_IMAGE_URL_KEY @"profileImageURL"
#define PROFILE_BACKGROUND_IMAGE_URL_KEY @"profileBackgroundImageURL"
#define TWEETS_COUNT_KEY @"tweetsCount"
#define FOLLOWERS_COUNT_KEY @"followersCount"
#define FOLLOWING_COUNT_KEY @"followingCount"

@interface User () <NSCoding>

@end

@implementation User

- (id) initWithDictionary: (NSDictionary *) dictionary {
  self = [super init];
  
  if (self) {
    self.name = dictionary[@"name"];
    self.screenName = dictionary[@"screen_name"];
    self.profileImageURL = dictionary[@"profile_image_url_https"];
    self.tweetsCount = dictionary[@"statuses_count"];
    self.followersCount = dictionary[@"followers_count"];
    self.followingCount = dictionary[@"friends_count"];
    self.profileBackgroundImageURL = dictionary[@"profile_background_image_url_https"];
  }
  
  return self;
}

+ (User *) currentUser {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *encodedUserObj = [defaults objectForKey:@"currentUser"];
  
  User *currentUser = nil;
  if (encodedUserObj != nil) {
    currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedUserObj];
  }

  return currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  NSData *encodedUserObj = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
  [defaults setObject:encodedUserObj forKey:@"currentUser"];
  [defaults synchronize];
}

#pragma mark -  NSCoding
- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.name forKey: NAME_KEY];
  [coder encodeObject:self.screenName forKey: SCREEN_NAME_KEY];
  [coder encodeObject:self.profileImageURL forKey: PROFILE_IMAGE_URL_KEY];
  [coder encodeObject:self.profileBackgroundImageURL forKey: PROFILE_BACKGROUND_IMAGE_URL_KEY];
  [coder encodeObject:self.tweetsCount forKey:TWEETS_COUNT_KEY];
  [coder encodeObject:self.followersCount forKey:FOLLOWERS_COUNT_KEY];
  [coder encodeObject:self.followingCount forKey:FOLLOWING_COUNT_KEY];
}

- (instancetype)initWithCoder:(NSCoder *)deCoder
{
  if (self = [super init]) {
    self.name = [deCoder decodeObjectForKey: NAME_KEY];
    self.screenName = [deCoder decodeObjectForKey: SCREEN_NAME_KEY];
    self.profileImageURL = [deCoder decodeObjectForKey: PROFILE_IMAGE_URL_KEY];
    self.profileBackgroundImageURL = [deCoder decodeObjectForKey: PROFILE_BACKGROUND_IMAGE_URL_KEY];
    self.tweetsCount = [deCoder decodeObjectForKey: TWEETS_COUNT_KEY];
    self.followersCount = [deCoder decodeObjectForKey: FOLLOWERS_COUNT_KEY];
    self.followingCount = [deCoder decodeObjectForKey: FOLLOWING_COUNT_KEY];
  }
  return self;
}

@end
