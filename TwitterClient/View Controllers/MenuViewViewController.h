//
//  MenuViewViewController.h
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 2/2/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerDelegate.h"

@interface MenuViewViewController : UIViewController

@property (nonatomic, weak, nullable) id <ViewControllerDelegate> delegate;

@end
