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
@synthesize postID;
@synthesize deleteAlert;
@synthesize deleteButton;
@synthesize reachable;

- (void)alertShow
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Whoa Buddy!" message:@"Please connect to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)checkRechability
{
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        reachable = true;
        if (self.navigationItem.rightBarButtonItem.enabled == NO) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
      
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        
        NSLog(@"UNREACHABLE!");
        reachable = false;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.quoteText setEditable:NO];
    self.authorText.enabled = NO;
    [self.sharedSwitch setEnabled:NO];
    
    quoteText.text = quoteString;
    authorText.text = authorString;
    
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        self.sharedSwitch.hidden = YES;
        self.editSaveButton.title = @"";
        self.editSaveButton.enabled = NO;
        self.deleteButton.hidden = YES;
        
    }
    
    if (![userNameString isEqualToString:[[PFUser currentUser]username]]){
        NSLog(@"%@",userNameString);
        self.sharedSwitch.hidden = YES;
        self.sharedLabel.hidden = YES;
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editSaveItem:(UIBarButtonItem *)sender {
    
    [self checkRechability];
    
    if (reachable == true) {
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
            [self saveParseObject];
            [self.navigationItem setLeftBarButtonItem:nil];
            [self.navigationItem setHidesBackButton:FALSE];
            
        }

    } else {
        [self alertShow];
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

- (IBAction)onDeleteClicked:(UIButton *)sender {
    [self deleteAlert];
}


-(UIAlertView*)deleteAlert
{
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Hold up!" message:@"You sure you want to delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    deleteAlert.tag = 1;
    
    [deleteAlert show];
    
    return deleteAlert;
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag ==0)
    {
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 1)
    {
        if (buttonIndex ==0)
        {
            [deleteAlert dismissWithClickedButtonIndex:0 animated:YES];
            NSLog(@"Cancel was hit");
        }
        else
        {
            NSLog(@"Delete  was hit");
            [self deleteItem];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}


-(void)deleteItem
{
    PFQuery *postFromCurrentUser = [PFQuery queryWithClassName:@"Quote"];
    PFObject *postToDelete = [postFromCurrentUser getObjectWithId:postID];
    [postToDelete deleteEventually];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Save Edit
- (void)saveParseObject {
    
    if (![self.quoteText.text isEqualToString:@""] && ![self.authorText.text isEqualToString:@""]) {
        PFACL *defaultACL = [PFACL ACL];
        [defaultACL setPublicReadAccess:YES];
        [defaultACL setPublicWriteAccess:YES];
        [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
        
        
        PFQuery *postFromCurrentUser = [PFQuery queryWithClassName:@"Quote"];
        
        // We create a new Parse object and set the data we want to store
        PFObject *postEdited = [postFromCurrentUser getObjectWithId:postID];
        
        [postEdited setObject: quoteText.text forKey:@"quote"];
        [postEdited setObject: authorText.text forKey:@"author"];
        
        if (!self.sharedSwitch.isOn) {
            
            PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [postACL setPublicReadAccess:NO];
            [postACL setPublicWriteAccess:NO];
            postEdited.ACL = postACL;
            NSLog(@"Switch is set to off");
        }
        
        // Create 1-1 relationship between the current user and the post
        [postEdited saveEventually:^(BOOL succeeded, NSError *error) {
            NSLog(@"Object saved to Parse! :)");
        }];
        
    }else if ([self.quoteText.text isEqualToString:@""] && [self.authorText.text isEqualToString:@""]){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Whoa there!" message:@"You didn't fill in the fields. " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else if ([self.quoteText.text isEqualToString:@""]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Whoa there!" message:@" Um..unless this is a lesson in zen you need to fill in the quote." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else if ([self.authorText.text isEqualToString:@""]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Whoa there!" message:@"Please tell us who said the quote" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
