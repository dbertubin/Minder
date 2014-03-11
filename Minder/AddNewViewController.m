//
//  AddNewViewController.m
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import "AddNewViewController.h"



@interface AddNewViewController ()

@end

@implementation AddNewViewController
@synthesize shared = _shared;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.quoteText.backgroundColor = [UIColor clearColor];
        self.authorText.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.quoteText.backgroundColor = [UIColor clearColor];
    self.authorText.backgroundColor = [UIColor clearColor];
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        [[[UIAlertView alloc] initWithTitle:@"Oops! Looks like you are not connected"
                                    message:@"Please find a network to use this app"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        //        [self.view setUserInteractionEnabled:NO];
        
        
    };
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveQuote{
    
    if (![self.quoteText.text isEqualToString:@""] && ![self.authorText.text isEqualToString:@""]) {
        PFACL *defaultACL = [PFACL ACL];
        [defaultACL setPublicReadAccess:YES];
        [defaultACL setPublicWriteAccess:YES];
        [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
        
        
        // We create a new Parse object and set the data we want to store
        PFObject *newQuote = [[PFObject alloc] initWithClassName:@"Quote"];
        
        [newQuote setObject: self.quoteText.text forKey:@"quote"];
        [newQuote setObject: self.authorText.text forKey:@"author"];
        
        if ([PFUser currentUser] != nil) {
            [newQuote setObject: [PFUser currentUser].username forKey:@"username"];
        } else {
            [newQuote setObject: @"Guest User" forKey:@"username"];
        }
        
        
        if (self.sharedSwitch.isOn) {
        } else {
            PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [postACL setPublicReadAccess:NO];
            [postACL setPublicWriteAccess:NO];
            newQuote.ACL = postACL;
            NSLog(@"Switch is set to off");
        }
        
        
        //    newQuote.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        //    // Create 1-1 relationship between the current user and the post
        if ([PFUser currentUser] != nil) {
            [newQuote setObject:[PFUser currentUser] forKey:@"fromUser"];
        } else {
            
        }
        
        [newQuote saveEventually:^(BOOL succeeded, NSError *error) {
            NSLog(@"Object saved to Parse! :)");
        }];
        
        [ self dismissViewControllerAnimated:YES completion:nil];
        
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





- (IBAction)onSavedClicked:(UIBarButtonItem *)sender {
    [self saveQuote];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)onCancelClicked:(UIBarButtonItem*)sender {
    [ self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
