//
//  SecondViewController.h
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SecondViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
- (IBAction)logOut:(id)sender;
- (IBAction)signIn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end
