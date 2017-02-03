//
//  TweetListViewController.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/30/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@interface TweetListViewController : UIViewController

@property int type;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray<Tweet *> *tweets;

+ (TweetListViewController *) initWithType:(int) type;

@end
