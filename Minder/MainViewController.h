//
//  MainViewController.h
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CustomTableViewCell.h"

@interface MainViewController : UITableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate >

@property (weak, nonatomic) IBOutlet UILabel *postedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;

@property (strong, nonatomic) NSMutableArray * quotes;
@property (weak, nonatomic) PFUser * currentUser;
@end
