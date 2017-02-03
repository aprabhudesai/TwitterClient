//
//  TableViewCellDelegate.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 2/2/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewCellDelegate <NSObject>

- (void) profileImageTappedForTableViewCell: (UITableViewCell *)cell;

@end
