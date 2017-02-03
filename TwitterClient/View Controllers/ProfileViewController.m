//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 2/1/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "TweetListViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *topContainer;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileBGImageTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *tableViewListContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tableViewSegmentedControl;
@property long currentTableViewControllerIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarContainerTopSpaceConstraint;

- (void) setupTabBar;
- (void) updateProfileViews;
- (void) loadTableViewController;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  self.currentTableViewControllerIndex = 0;

  [self.tableViewSegmentedControl addTarget:self action:@selector(onTableViewSegmentedControlChange:) forControlEvents:UIControlEventValueChanged];
  [self loadTableViewController];
  
  [self updateProfileViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Self Methods
- (void)setupTabBar {
   self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile_icon"] tag:2];
}

- (void)updateProfileViews {
  
//  UIView *view = [[UIView alloc] initWithFrame:self.topContainer.frame];
//  CAGradientLayer *gradient = [CAGradientLayer layer];
//  
//  gradient.frame = view.bounds;
//  gradient.colors = @[(id)[UIColor colorWithRed:29/255 green:136/255 blue:201/255 alpha:1].CGColor, (id)[UIColor colorWithRed:50/255 green:164/255 blue:181/255 alpha:1].CGColor];
//  
//  [self.topContainer.layer insertSublayer:gradient atIndex:0];
  
  User *currentUser = self.user;
  
  [self.profileImageView setImageWithURL:[NSURL URLWithString:currentUser.profileImageURL]];
  [self.profileBackgroundImageView setImageWithURL:[NSURL URLWithString:currentUser.profileBackgroundImageURL]];
  self.nameLabel.text = currentUser.name;
  self.handleLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];
  self.tweetCountLabel.text = [NSString stringWithFormat:@"%d", [currentUser.tweetsCount intValue]];
  self.followersCountLabel.text = [NSString stringWithFormat:@"%d", [currentUser.followersCount intValue]];
  self.followingCountLabel.text = [NSString stringWithFormat:@"%d", [currentUser.followingCount intValue]];
  
  if (self.navigationController.navigationBar) {
    self.topBarContainerTopSpaceConstraint.constant = self.navigationController.navigationBar.bounds.size.height + 20;
  }
}

- (void)loadTableViewController {
  TweetListViewController *tweetListViewController = nil;
  if (self.currentTableViewControllerIndex == 0) {
    tweetListViewController = [TweetListViewController initWithType:3];
  }
  else if (self.currentTableViewControllerIndex == 1) {
    tweetListViewController = [TweetListViewController initWithType:4];
  }
  tweetListViewController.user = self.user;
  [tweetListViewController.view setFrame:self.tableViewListContainer.bounds];
  [self addChildViewController:tweetListViewController];
  [self.tableViewListContainer addSubview:tweetListViewController.view];
}

#pragma mark - Actions
- (void) onTableViewSegmentedControlChange:(UISegmentedControl *)sender {
  self.currentTableViewControllerIndex = sender.selectedSegmentIndex;
  [self loadTableViewController];
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
