//
//  DetailViewController.h
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *quoteText;
@property (weak, nonatomic) IBOutlet UITextField *authorText;
@property (weak, nonatomic) IBOutlet UISwitch *sharedSwitch;
@property (weak, nonatomic) IBOutlet UILabel *sharedLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editSaveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) NSString * quoteString;
@property (weak, nonatomic) NSString * authorString;
@property (weak, nonatomic) NSString * userNameString;


@property UIBarButtonItem *leftBarButton;

- (IBAction)editSaveItem:(UIBarButtonItem *)sender;

- (IBAction)onCancel:(UIBarButtonItem *)sender;

@end
