//
//  TweetTableViewCell.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 1/30/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TableViewCellDelegate.h"

@interface TweetTableViewCell : UITableViewCell

NS_ASSUME_NONNULL_BEGIN
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic, weak, nullable) id <TableViewCellDelegate> delegate;
- (void) updateCellWithModel: (Tweet *) tweet;
NS_ASSUME_NONNULL_END

@end
