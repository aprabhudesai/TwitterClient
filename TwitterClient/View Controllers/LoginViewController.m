//
//  LoginViewController.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetListViewController.h"
#import "ProfileViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
  
  [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {

    if (user != nil) {
      // Modally present the tweets view
      [[TwitterClient sharedInstance]
       homeTimelineFromTweetID:nil
       andNewData:NO
       WithSuccess:^(NSArray<Tweet *> *tweets) {
         TweetListViewController *tweetListViewController = [TweetListViewController initWithType:1];
         tweetListViewController.tweets = [NSMutableArray arrayWithArray:tweets];
         
         UINavigationController *tweetNavController = [[UINavigationController alloc] initWithRootViewController:tweetListViewController];

         // Instantiate the TweetsListViewController for Mentions Timeline
         TweetListViewController *tweetListForMentionsTimeLineViewController = [TweetListViewController initWithType:2];
         UINavigationController *tweetMentionsTimeLineNavController = [[UINavigationController alloc] initWithRootViewController:tweetListForMentionsTimeLineViewController];
         
         ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
         profileViewController.user = [User currentUser];
         
         UITabBarController *tabBarController = [[UITabBarController alloc] init];
         [tabBarController setViewControllers:@[tweetNavController, tweetMentionsTimeLineNavController, profileViewController]];
         [tabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
         [tabBarController.tabBar setTintColor:[UIColor colorWithRed:29.0f/255 green:161.0f/255 blue:(242.0f/255) alpha:1.0]];
         
         tweetListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home_icon"] tag:1];
         
         tweetListForMentionsTimeLineViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:[UIImage imageNamed:@"notification_icon"] tag:2];
         
         profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile_icon"] tag:3];

         [self presentViewController:tabBarController animated:YES completion:nil];
      
       }
       andFailure:^(NSError *error) {
         NSLog(@"Error Getting Timeline: %@", error.localizedDescription);
       }
      ];
    }
    else {
      // Present the error view
    }
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
