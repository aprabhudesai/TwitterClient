//
//  MenuViewViewController.m
//  TwitterClient
//
//  Created by Abhishek Prabhudesai on 2/2/17.
//  Copyright © 2017 Abhishek Prabhudesai. All rights reserved.
//

#import "MenuViewViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MenuViewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileHeaderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIButton *signoutButton;

@end

@implementation MenuViewViewController

- (IBAction)onSignout:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(onButtonTapped:)]) {
    [self.delegate onButtonTapped:self.signoutButton];
  }
//  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//  [[TwitterClient sharedInstance] logout];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  User *currentUser = [User currentUser];
  [self.profileHeaderImageView setImageWithURL:[NSURL URLWithString:currentUser.profileBackgroundImageURL]];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:currentUser.profileImageURL]];
  self.nameLabel.text = currentUser.name;
  self.handleLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
