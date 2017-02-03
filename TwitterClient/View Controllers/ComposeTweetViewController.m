//
//  ComposeTweetViewController.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/31/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import "TweetListViewController.h"
#import "Tweet.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ComposeTweetViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContainerTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (strong, nonatomic) UIBarButtonItem *countButton;

@end

@implementation ComposeTweetViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  User *currentUser = [User currentUser];

  // Do any additional setup after loading the view from its nib.
  self.nameLabel.text = currentUser.name;
  self.handleLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:currentUser.profileImageURL]];
  
  self.tweetTextView.delegate = self;
  self.tweetTextView.text = @"";
  [self.tweetTextView becomeFirstResponder];
  
  NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor], NSForegroundColorAttributeName,
                                  nil];
  
  self.navigationController.navigationBar.titleTextAttributes = textAttributes;
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:29.0f/255 green:161.0f/255 blue:(242.0f/255) alpha:1.0]];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
  
  UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
  
  self.countButton = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:nil action:nil];
  
  [self.countButton setTintColor:[UIColor whiteColor]];
  
//  UILabel *charCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//  charCountLabel.text = @"0";
//  charCountLabel.tintColor = [UIColor whiteColor];
//
//  UIBarButtonItem *charCountBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:charCountLabel];
  
  
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItems = @[tweetButton, self.countButton];
  
  self.topContainerTopSpaceConstraint.constant = self.navigationController.navigationBar.frame.size.height + 12;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void) onCancelButton {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) onTweetButton {
  NSString *tweetText = self.tweetTextView.text;

  if (![tweetText isEqualToString:@""]) {
    [[TwitterClient sharedInstance] postTweet:tweetText onSuccess:^ (NSDictionary *responseDictionary) {
//      long navControllerCount = self.navigationController.viewControllers.count;
      
//      TweetListViewController *prevController = self.navigationController.viewControllers[navControllerCount - 2];
//      
//      Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseDictionary];
//      
//      NSMutableArray *newTweetsArray = [NSMutableArray array];
//      [newTweetsArray addObject:newTweet];
//      [newTweetsArray addObjectsFromArray:prevController.tweets];
//      prevController.tweets = newTweetsArray;
      [self.navigationController popViewControllerAnimated:YES];
    } onFailure:^(NSError *error) {
      NSLog(@"Error Posting Tweet %@", error);
    }];
  }
}

#pragma mark - Text View Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  long textLen = textView.text.length + (text.length - range.length);
  long remainingChars = 140 - textLen;
  [self.countButton setTitle:[NSString stringWithFormat:@"%ld", remainingChars]];
  return textLen <= 140;
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
