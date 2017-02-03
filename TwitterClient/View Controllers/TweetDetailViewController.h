//
//  TweetDetailViewController.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/31/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property BOOL isReply;

@end
