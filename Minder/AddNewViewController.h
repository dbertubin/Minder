//
//  AddNewViewController.h
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MainViewController.h"
#import "Reachability.h"

@interface AddNewViewController : UIViewController <UIAlertViewDelegate>

- (IBAction)onSavedClicked:(UIButton *)sender;
- (IBAction)onCancelClicked:(UIButton *)sender;

@property int reachable;
@property (weak, nonatomic) IBOutlet UITextView *quoteText;
@property (weak, nonatomic) IBOutlet UITextField *authorText;
@property (weak, nonatomic) IBOutlet UISwitch *sharedSwitch;
@property (nonatomic) Boolean * shared;



@end
