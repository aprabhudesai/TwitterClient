//
//  ViewControllerDelegate.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 2/3/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>

- (void) onButtonTapped: (UIButton *) button;

@end
