//
//  DetailViewController.m
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import "DetailViewController.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize editSaveButton;
@synthesize quoteText;
@synthesize authorText;
@synthesize sharedLabel;
@synthesize sharedSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.quoteText setEditable:NO];
    [self.sharedSwitch setEnabled:NO];
    [self.cancelButton setTitle:@""];
    [self.cancelButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editSaveItem:(UIBarButtonItem *)sender {
    
    if ([self.editSaveButton.title  isEqual: @"Edit"]) {
        self.editSaveButton.title = @"Save";
        [self.quoteText setEditable:YES];
        [self.quoteText becomeFirstResponder];
        [self.sharedSwitch setEnabled:YES];
        [self.cancelButton setTitle:@"Cancel"];
        [self.cancelButton setEnabled:YES];
    } else {
        self.editSaveButton.title = @"Edit";
        [self.quoteText setEditable:NO];
        [self.quoteText resignFirstResponder];
        [self.sharedSwitch setEnabled:NO];
        [self.cancelButton setTitle:@""];
        [self.cancelButton setEnabled:NO];
    }
    
    
    
    
    
    
}

- (IBAction)onCancel:(UIBarButtonItem *)sender {
    self.editSaveButton.title = @"Edit";
    [self.quoteText setEditable:NO];
    [self.quoteText resignFirstResponder];
    [self.sharedSwitch setEnabled:NO];
    [self.cancelButton setTitle:@""];
    [self.cancelButton setEnabled:NO];
}
@end
