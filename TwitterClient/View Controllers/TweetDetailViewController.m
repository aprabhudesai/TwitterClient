//
//  TweetDetailViewController.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/31/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *retweetContainer;
@property (weak, nonatomic) IBOutlet UILabel *retweetHandleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@property (weak, nonatomic) IBOutlet UIScrollView *tweetScrollView;
@property (weak, nonatomic) IBOutlet UIView *replyContainer;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;

@property (weak, nonatomic) IBOutlet UIButton *replyToTweetButton;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileContainerTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerTopSpaceConstraint;

// Private Methods
- (void) updateDetailScreen;
- (void) setReplyContainerVisibility:(BOOL) visibility;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view from its nib.
  NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor], NSForegroundColorAttributeName,
                                  nil];
  
  self.navigationController.navigationBar.titleTextAttributes = textAttributes;
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:29.0f/255 green:161.0f/255 blue:(242.0f/255) alpha:1.0]];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
  
//  UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
  
  self.navigationController.navigationItem.leftBarButtonItem = backButton;
  
  if (self.tweet.hasRetweetes) {
    self.retweetHandleLabel.text = self.tweet.retweetUser.screenName;
    self.retweetContainerTopSpaceConstraint.constant = self.navigationController.navigationBar.frame.size.height + 25;
  }
  else {
    self.retweetContainerTopSpaceConstraint.constant = 0;
    self.profileContainerTopSpaceConstraint.constant = self.navigationController.navigationBar.frame.size.height + 12;
    [self.retweetContainer.subviews setValue:@YES forKey:@"hidden"];
  }
  
  [self updateDetailScreen];
  
  if (self.isReply) {
    [self prepareForReply];
  }
  else {
    [self setReplyContainerVisibility:YES];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void) onBackButton {
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onRetweet:(id)sender {
  [[TwitterClient sharedInstance] reTweet:self.tweet.tweetId onSuccess:^(NSDictionary *responseDictionary) {
    NSLog(@"Retweeted: %@", responseDictionary);
    self.tweet.retweetCount = responseDictionary[@"retweet_count"];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld",[self.tweet.retweetCount integerValue]];
  } onFailure:^(NSError *error) {
    NSLog(@"Error Retweeting %@", error);
  }];
}

- (IBAction)onFavorite:(id)sender {
  [[TwitterClient sharedInstance] favoriteTweet:self.tweet.tweetId onSuccess:^(NSDictionary *responseDictionary) {
    NSLog(@"Favorite: %@", responseDictionary);
    self.tweet.favoriteCount = responseDictionary[@"favorite_count"];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", [self.tweet.favoriteCount integerValue]];
  } onFailure:^(NSError *error) {
    NSLog(@"Error Making Favorite %@", error);
  }];
}

- (IBAction)onReply:(id)sender {
  [self prepareForReply];
}

- (IBAction)onReplyButtonTapped:(id)sender {
  [self setReplyContainerVisibility:YES];
  [self.tweetScrollView setContentOffset:CGPointZero animated:YES];
  
  NSString *replyText = [NSString stringWithFormat:@"%@", self.replyTextField.text];
  [[TwitterClient sharedInstance] replyToTweet:self.tweet.tweetId withText:replyText onSuccess:^(NSDictionary *responseDictionary) {
    NSLog(@"Reply: %@", responseDictionary);
    [self setReplyContainerVisibility:YES];
    [self.replyTextField resignFirstResponder];
    [self.tweetScrollView setContentOffset:CGPointMake(0, 0)];
  } onFailure:^(NSError *error) {
    NSLog(@"Error Replying %@", error);
  }];
}

#pragma mark - Self Methods
- (void) updateDetailScreen {
  self.nameLabel.text = self.tweet.user.name;
  self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageURL]];
  self.tweetTextLabel.text = self.tweet.text;
  self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld",[self.tweet.retweetCount integerValue]];
  self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", [self.tweet.favoriteCount integerValue]];
  
  if (self.tweet.isFavorited) {
    [self.favoriteButton setImage:[UIImage imageNamed:@"twitter_favorite_red_icon"] forState:UIControlStateNormal];
  }
  
  if (self.tweet.isRetweeted) {
    [self.retweetButton setImage:[UIImage imageNamed:@"twitter_retweet_icon_green"] forState:UIControlStateNormal];
  }
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  
  formatter.dateFormat = @"MM/dd/yy hh:mm a";
  self.timestampLabel.text = [formatter stringFromDate:self.tweet.createdAt];
}

- (void) setReplyContainerVisibility: (BOOL)visibility {
  self.replyContainer.hidden = visibility;
  [self.replyContainer.subviews setValue:[NSNumber numberWithBool:visibility] forKey:@"hidden"];
}

- (void) prepareForReply {
  [self setReplyContainerVisibility:NO];
  
  self.replyTextField.text = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tweetScrollView setContentSize:CGSizeMake(self.tweetScrollView.bounds.size.width, self.tweetScrollView.bounds.size.height + 50)];
    [self.tweetScrollView setContentOffset:CGPointMake(self.replyContainer.bounds.origin.x, self.replyContainer.bounds.origin.y + 50) animated:YES];
  });
  [self.replyTextField becomeFirstResponder];
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
