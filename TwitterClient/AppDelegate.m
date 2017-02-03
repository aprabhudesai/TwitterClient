//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/29/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetListViewController.h"
#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  CGRect frame = [[UIScreen mainScreen] bounds];
  self.window = [[UIWindow alloc] initWithFrame: frame];
  
  User *currentUser = [User currentUser];
  __block LoginViewController *loginController = nil;
  if (currentUser != nil) {
    // Instantiate the TweetsListViewController for Home Timeline
    TweetListViewController *tweetListForHomeTimeLineViewController = [TweetListViewController initWithType:1];
    UINavigationController *tweetHomeTimeLineNavController = [[UINavigationController alloc] initWithRootViewController:tweetListForHomeTimeLineViewController];
    
    // Instantiate the TweetsListViewController for Mentions Timeline
    TweetListViewController *tweetListForMentionsTimeLineViewController = [TweetListViewController initWithType:2];
    UINavigationController *tweetMentionsTimeLineNavController = [[UINavigationController alloc] initWithRootViewController:tweetListForMentionsTimeLineViewController];
    
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.user = [User currentUser];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[tweetHomeTimeLineNavController, tweetMentionsTimeLineNavController, profileViewController]];

    [tabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
    [tabBarController.tabBar setTintColor:[UIColor colorWithRed:29.0f/255 green:161.0f/255 blue:(242.0f/255) alpha:1.0]];

    tweetListForHomeTimeLineViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home_icon"] tag:1];
    
    tweetListForMentionsTimeLineViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:[UIImage imageNamed:@"notification_icon"] tag:2];
    
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile_icon"] tag:3];
    
    self.window.rootViewController = tabBarController;
  }
  else {
    // Instantiate the LoginViewController
    loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = loginController;
  }

  [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidLogout" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
    NSLog(@"Logout; %@", loginController);
    if (loginController == nil) {
      loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    self.window.rootViewController = loginController;
    [self.window makeKeyAndVisible];
  }];

  [self.window makeKeyAndVisible];
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  
  [[TwitterClient sharedInstance] openURL:url];
  return YES;
}

@end
