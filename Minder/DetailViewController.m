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
@synthesize quoteString;
@synthesize authorString;
@synthesize leftBarButton;
@synthesize userNameString;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.quoteText setEditable:NO];
    self.authorText.enabled = NO;
    [self.sharedSwitch setEnabled:NO];
    
    quoteText.text = quoteString;
    authorText.text = authorString;
    
    if (![userNameString isEqualToString:[[PFUser currentUser]username]]) {
        self.sharedSwitch.hidden = YES;
        self.editSaveButton.title = @"";
        self.editSaveButton.enabled = NO;
    }
    
    
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
        self.authorText.enabled = YES;
        [self.navigationItem setHidesBackButton:TRUE];
        
        leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
        [self.navigationItem setLeftBarButtonItem:leftBarButton];
        
        
    } else {
        self.editSaveButton.title = @"Edit";
        [self.quoteText setEditable:NO];
        [self.quoteText resignFirstResponder];
        [self.sharedSwitch setEnabled:NO];
        
        
    }

}

- (IBAction)onCancel:(UIBarButtonItem *)sender {
    
    
    self.editSaveButton.title = @"Edit";
    [self.quoteText setEditable:NO];
    [self.quoteText resignFirstResponder];
    [self.sharedSwitch setEnabled:NO];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setHidesBackButton:FALSE];
    
    
}
@end
