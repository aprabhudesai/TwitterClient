//
//  User.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *profileBackgroundImageURL;
@property (class, strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSNumber *tweetsCount;
@property (strong, nonatomic) NSNumber *followersCount;
@property (strong, nonatomic) NSNumber *followingCount;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
