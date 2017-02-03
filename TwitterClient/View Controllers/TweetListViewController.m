//
//  TweetListViewController.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/30/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "TweetListViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"
#import "TweetDetailViewController.h"
#import "ProfileViewController.h"
#import "MenuViewViewController.h"

#define CELL_REUSE_ID @"TweetTableViewCell"

@interface TweetListViewController () <UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, ViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property BOOL isMoreDataLoading;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuLeftMarginConstraint;
@property CGFloat originalLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeftMarginConstraint;
@property (strong, nonatomic) MenuViewViewController *menuViewController;


- (void) setupNavigationBar;
- (void) setupTabBar;
- (void) fetchHomeTimeLine: (BOOL)isNew;
- (void) fetchMentionsTimeLine: (BOOL)isNew;
- (void) fetchUserTimeLine: (BOOL)isNew;
- (void) fetchUserFavoriteList: (BOOL) isNew;

@end

@implementation TweetListViewController

- (void)viewWillAppear:(BOOL)animated {
  BOOL isNew = NO;
  if (self.tweets.count > 0) {
    isNew = YES;
  }
  [super viewWillAppear:animated];
  if (self.type == 1) {
    [self fetchHomeTimeLine:isNew];
  }
  else if (self.type == 2) {
    [self fetchMentionsTimeLine:isNew];
  }
  else if (self.type == 3) {
    [self fetchUserTimeLine:isNew];
  }
  else if (self.type == 4) {
    [self fetchUserFavoriteList:isNew];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.navigationController.navigationBar) {
    self.tableViewTopSpaceConstraint.constant = self.navigationController.navigationBar.bounds.size.height + 20;
  }
  UIPanGestureRecognizer *gestureRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
  gestureRecog.delegate = self;
  
  self.menuViewController = [[MenuViewViewController alloc] initWithNibName:@"MenuViewViewController" bundle:nil];
  [self.menuView addSubview:self.menuViewController.view];
  self.menuViewController.delegate = self;
  
  [self.tableView addGestureRecognizer:gestureRecog];
  self.isMoreDataLoading = false;
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
  [self.tableView insertSubview:self.refreshControl atIndex:0];
  self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  
  UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
  self.loadingView.center = tableFooterView.center;
  [tableFooterView addSubview:self.loadingView];
  self.tableView.tableFooterView = tableFooterView;
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.estimatedRowHeight = 200;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  UINib *nib = [UINib nibWithNibName:CELL_REUSE_ID bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:CELL_REUSE_ID];

  if (self.type != 3 && self.type != 4) {
    [self setupNavigationBar];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization
+ (TweetListViewController *) initWithType:(int)type {
  TweetListViewController *tweetListViewController = [[TweetListViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
  tweetListViewController.type = type;
  
  return tweetListViewController;
}

#pragma mark - Pan Gesture Recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
  CGPoint velocity = [gestureRecognizer velocityInView:self.view];
  if ((velocity.x < 0 && self.tableViewLeftMarginConstraint.constant == 0) ||
      velocity.y != 0) {
    return NO;
  }
  return YES;
}

#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tweets.count;
}

- (void) onPanGesture:(UIPanGestureRecognizer *)sender {
  CGPoint translation = [sender translationInView:self.view];
  CGPoint velocity = [sender velocityInView:self.view];
  if (sender.state == UIGestureRecognizerStateBegan) {
    self.originalLeftMargin = self.tableViewLeftMarginConstraint.constant;
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    self.tableViewLeftMarginConstraint.constant = self.originalLeftMargin + translation.x;
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    [UIView animateWithDuration:0.3 animations:^{
      if (velocity.x > 0) {
        self.tableViewLeftMarginConstraint.constant = self.tableView.frame.size.width - 49;
      }
      else {
        self.tableViewLeftMarginConstraint.constant = 0;
      }
      [self.view layoutIfNeeded];
    }];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID forIndexPath:indexPath];
  cell.replyButton.tag = indexPath.row;
  [cell.replyButton addTarget:self action:@selector(onReplyButton:) forControlEvents:UIControlEventTouchUpInside];
  
  cell.retweetButton.tag = indexPath.row;
  [cell.retweetButton addTarget:self action:@selector(onRetweetButton:) forControlEvents:UIControlEventTouchUpInside];
  
  cell.favoriteButton.tag = indexPath.row;
  [cell.favoriteButton addTarget:self action:@selector(onFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
  
  cell.delegate = self;

  Tweet *currentTweet = [self.tweets objectAtIndex:indexPath.row];
  [cell updateCellWithModel:currentTweet];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  TweetTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  Tweet *selectedTweet = [self.tweets objectAtIndex:indexPath.row];
  TweetDetailViewController *tweetDetaiViewController = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];
  
  tweetDetaiViewController.tweet = selectedTweet;
  
  UIView *bgView = [[UIView alloc] init];
  bgView.backgroundColor = [UIColor whiteColor];
  cell.selectedBackgroundView = bgView;
  
  [self.navigationController pushViewController:tweetDetaiViewController animated:YES];
}

#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!self.isMoreDataLoading) {
    CGFloat scrollContentHeigth = self.tableView.contentSize.height;
    CGFloat scrollOffsetThreshold = scrollContentHeigth - self.tableView.bounds.size.height;
    
    if (scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
      self.isMoreDataLoading = true;
      [self.loadingView startAnimating];
      if (self.type == 1) {
        [self fetchHomeTimeLine:NO];
      }
      else if (self.type == 2) {
        [self fetchMentionsTimeLine:NO];
      }
      else if (self.type == 3) {
        [self fetchUserTimeLine:NO];
      }
      else if (self.type == 4) {
        [self fetchUserFavoriteList:NO];
      }
    }
  }
}

#pragma mark - Self Methods
- (void)setupNavigationBar {
  NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor], NSForegroundColorAttributeName,
                                  nil];
  
  self.navigationController.navigationBar.titleTextAttributes = textAttributes;
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:29.0f/255 green:161.0f/255 blue:(242.0f/255) alpha:1.0]];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
  self.navigationItem.title = @"Home";
  
  // UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut)];
  UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
  
  UIBarButtonItem *composeMessageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_icon_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
  
  self.navigationItem.leftBarButtonItem = menuButton;
  self.navigationItem.rightBarButtonItem = composeMessageButton;
}

- (void) setupTabBar {
  NSString *tabBarItemImageString;
  if (self.type == 1) {
    tabBarItemImageString = @"home_icon";
  }
  else if (self.type == 2) {
    tabBarItemImageString = @"notification_icon";
  }
  self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:tabBarItemImageString] tag:self.type];
}

#pragma mark - Actions
- (void) onSignOut {
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  [[TwitterClient sharedInstance] logout];

}

- (void) onCompose{
  ComposeTweetViewController *composeTweetController = [[ComposeTweetViewController alloc] initWithNibName:@"ComposeTweetViewController" bundle:nil];
  
  [self.navigationController pushViewController:composeTweetController animated:YES];
}

- (void) onRefresh {
  [self.refreshControl beginRefreshing];
  [self fetchHomeTimeLine:YES];
}

- (void) onReplyButton:(UIButton *) sender {
  Tweet *selectedTweet = [self.tweets objectAtIndex:sender.tag];
  TweetDetailViewController *tweetDetaiViewController = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];
  
  tweetDetaiViewController.tweet = selectedTweet;
  tweetDetaiViewController.isReply = YES;
  [self.navigationController pushViewController:tweetDetaiViewController animated:YES];
}

- (void) onRetweetButton:(UIButton *) sender {
  Tweet *selectedTweet = [self.tweets objectAtIndex:sender.tag];
  [[TwitterClient sharedInstance] reTweet:selectedTweet.tweetId onSuccess:^(NSDictionary *dictionary) {
    NSLog(@"Retweeted Successfully %@", dictionary);
    selectedTweet.isRetweeted = YES;
    selectedTweet.retweetCount = dictionary[@"retweet_count"];
    [self.tableView reloadData];
  } onFailure:^(NSError *error) {
    NSLog(@"Error Retweeting %@", error.localizedDescription);
  }];
}

- (void) onFavoriteButton:(UIButton *) sender {
  Tweet *selectedTweet = [self.tweets objectAtIndex:sender.tag];
  [[TwitterClient sharedInstance] favoriteTweet:selectedTweet.tweetId onSuccess:^(NSDictionary *dictionary) {
    NSLog(@"Marked Favorite Successfully %@", dictionary);
    selectedTweet.isFavorited = YES;
    selectedTweet.favoriteCount = dictionary[@"favorite_count"];
    [self.tableView reloadData];
  } onFailure:^(NSError *error) {
    NSLog(@"Error Marking Favorite %@", error.localizedDescription);
  }];
}

- (void)onMenuButton:(UIBarButtonItem *)sender {
  if (self.tableViewLeftMarginConstraint.constant == 0) {
    [UIView animateWithDuration:0.3 animations:^{
      self.tableViewLeftMarginConstraint.constant = self.tableView.frame.size.width - 49;
      [self.view layoutIfNeeded];
    }];
  }
  else {
    [UIView animateWithDuration:0.3 animations:^{
      self.tableViewLeftMarginConstraint.constant = 0;
      [self.view layoutIfNeeded];
    }];
  }
}

- (void)onButtonTapped:(UIButton *)button {
  if ([button.restorationIdentifier isEqualToString:@"menuSignOut"]) {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[TwitterClient sharedInstance] logout];
  }
}


- (void)profileImageTappedForTableViewCell:(UITableViewCell *)cell {
  NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
  Tweet *selectedTweet = [self.tweets objectAtIndex:selectedIndexPath.row];
  ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
  profileViewController.user = selectedTweet.user;
  [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - Twitter API
- (void) fetchHomeTimeLine:(BOOL)isNew {
  NSString *tweetId = nil;
  if (self.tweets.count > 0) {
    if (isNew) {
      tweetId = [self.tweets objectAtIndex:0].tweetId;
    }
    else {
      tweetId = [self.tweets objectAtIndex:self.tweets.count - 1].tweetId;
    }
  }
  [[TwitterClient sharedInstance]
   homeTimelineFromTweetID:tweetId
   andNewData:isNew
   WithSuccess:^(NSArray<Tweet *> *tweets) {
     if (self.tweets.count > 0) {
       if (tweets.count == 1 && [tweets[0].tweetId isEqualToString:tweetId]) {
         return;
       }
       if (isNew) {
         NSMutableArray *newTweetsArray = [NSMutableArray arrayWithArray:tweets];
         [newTweetsArray addObjectsFromArray:self.tweets];
         self.tweets = newTweetsArray;
       }
       else {
         [self.loadingView stopAnimating];
         [self.tweets addObjectsFromArray:tweets];
       }
     }
     else {
       self.tweets = [NSMutableArray arrayWithArray:tweets];
     }
     self.isMoreDataLoading = false;
     [self.refreshControl endRefreshing];
     [self.tableView reloadData];
   }
   andFailure:^(NSError *error) {
     [self.refreshControl endRefreshing];
     NSLog(@"Error Getting Timeline: %@", error.localizedDescription);
   }
  ];
}

- (void)fetchMentionsTimeLine:(BOOL)isNew {
  NSString *tweetId = nil;
  if (self.tweets.count > 0) {
    if (isNew) {
      tweetId = [self.tweets objectAtIndex:0].tweetId;
    }
    else {
      tweetId = [self.tweets objectAtIndex:self.tweets.count - 1].tweetId;
    }
  }
  [[TwitterClient sharedInstance]
   mentionsTimelineFromTweetID:tweetId
   andNewData:isNew
   WithSuccess:^(NSArray<Tweet *> *tweets) {
     if (self.tweets.count > 0) {
       if (tweets.count == 1 && [tweets[0].tweetId isEqualToString:tweetId]) {
         return;
       }
       if (isNew) {
         NSMutableArray *newTweetsArray = [NSMutableArray arrayWithArray:tweets];
         [newTweetsArray addObjectsFromArray:self.tweets];
         self.tweets = newTweetsArray;
       }
       else {
         [self.loadingView stopAnimating];
         [self.tweets addObjectsFromArray:tweets];
       }
     }
     else {
       self.tweets = [NSMutableArray arrayWithArray:tweets];
     }
     self.isMoreDataLoading = false;
     [self.refreshControl endRefreshing];
     [self.tableView reloadData];
   }
   andFailure:^(NSError *error) {
     [self.refreshControl endRefreshing];
     NSLog(@"Error Getting Timeline: %@", error.localizedDescription);
   }
   ];
}

- (void)fetchUserTimeLine:(BOOL)isNew {
  NSString *tweetId = nil;
  if (self.tweets.count > 0) {
    if (isNew) {
      tweetId = [self.tweets objectAtIndex:0].tweetId;
    }
    else {
      tweetId = [self.tweets objectAtIndex:self.tweets.count - 1].tweetId;
    }
  }
  [[TwitterClient sharedInstance]
   userTimelineForUserScreenName:self.user.screenName
   fromTweetID:tweetId
   andNewData:isNew
   WithSuccess:^(NSArray<Tweet *> *tweets) {
     if (self.tweets.count > 0) {
       if (tweets.count == 1 && [tweets[0].tweetId isEqualToString:tweetId]) {
         return;
       }
       if (isNew) {
         NSMutableArray *newTweetsArray = [NSMutableArray arrayWithArray:tweets];
         [newTweetsArray addObjectsFromArray:self.tweets];
         self.tweets = newTweetsArray;
       }
       else {
         [self.loadingView stopAnimating];
         [self.tweets addObjectsFromArray:tweets];
       }
     }
     else {
       self.tweets = [NSMutableArray arrayWithArray:tweets];
     }
     self.isMoreDataLoading = false;
     [self.refreshControl endRefreshing];
     [self.tableView reloadData];
   }
   andFailure:^(NSError *error) {
     [self.refreshControl endRefreshing];
     NSLog(@"Error Getting Timeline: %@", error.localizedDescription);
   }
   ];
}

- (void)fetchUserFavoriteList:(BOOL)isNew {
  NSString *tweetId = nil;
  if (self.tweets.count > 0) {
    if (isNew) {
      tweetId = [self.tweets objectAtIndex:0].tweetId;
    }
    else {
      tweetId = [self.tweets objectAtIndex:self.tweets.count - 1].tweetId;
    }
  }
  [[TwitterClient sharedInstance]
   favoriteListForUserScreenName:self.user.screenName
   fromTweetID:tweetId
   andNewData:isNew
   WithSuccess:^(NSArray<Tweet *> *tweets) {
     if (self.tweets.count > 0) {
       if (tweets.count == 1 && [tweets[0].tweetId isEqualToString:tweetId]) {
         return;
       }
       if (isNew) {
         NSMutableArray *newTweetsArray = [NSMutableArray arrayWithArray:tweets];
         [newTweetsArray addObjectsFromArray:self.tweets];
         self.tweets = newTweetsArray;
       }
       else {
         [self.loadingView stopAnimating];
         [self.tweets addObjectsFromArray:tweets];
       }
     }
     else {
       self.tweets = [NSMutableArray arrayWithArray:tweets];
     }
     self.isMoreDataLoading = false;
     [self.refreshControl endRefreshing];
     [self.tableView reloadData];
   }
   andFailure:^(NSError *error) {
     [self.refreshControl endRefreshing];
     NSLog(@"Error Getting Favorites: %@", error.localizedDescription);
   }];
}

@end
