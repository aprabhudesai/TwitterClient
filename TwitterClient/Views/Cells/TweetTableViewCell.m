//
//  TweetTableViewCell.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/30/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "TweetTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TweetTableViewCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *retweetContainer;
@property (weak, nonatomic) IBOutlet UILabel *retweetHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.nameLabel.text = @"";
  self.handleLabel.text = @"";
  
  self.timestampLabel.text = @"";
  self.contentLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithModel:(Tweet *)tweet {
  [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
  self.nameLabel.text = tweet.user.name;
  self.handleLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
 
  NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
  formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
  formatter.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  formatter.maximumUnitCount = 1;
  NSString *elapsed = [formatter stringFromDate:tweet.createdAt toDate:[NSDate date]];
  
  self.timestampLabel.text = elapsed;
  self.contentLabel.text = tweet.text;

  self.profileImageView.layer.cornerRadius = 10.0;
  self.profileImageView.layer.masksToBounds = YES;

  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileImageTap:)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [tapGestureRecognizer setNumberOfTouchesRequired:1];
  [tapGestureRecognizer setDelegate:self];
  
  [self.profileImageView addGestureRecognizer:tapGestureRecognizer];
  
  if (tweet.hasRetweetes) {
    // Populate the retweet content
    self.retweetHandleLabel.text = [NSString stringWithFormat:@"@%@", tweet.retweetUser.screenName];
  }
  else {
    // Hide the retweet container
    self.retweetContainerHeightConstraint.constant = 0;
    [self.retweetContainer.subviews setValue:@YES forKey:@"hidden"];
  }
  
  if (tweet.isFavorited) {
    [self.favoriteButton setImage:[UIImage imageNamed:@"twitter_favorite_red_icon"] forState:UIControlStateNormal];
  }
  
  if (tweet.isRetweeted) {
    [self.retweetButton setImage:[UIImage imageNamed:@"twitter_retweet_icon_green"] forState:UIControlStateNormal];
  }
}

- (void) onProfileImageTap: (UITapGestureRecognizer *)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(profileImageTappedForTableViewCell:)]) {
    [self.delegate profileImageTappedForTableViewCell:self];
  }
}

@end
