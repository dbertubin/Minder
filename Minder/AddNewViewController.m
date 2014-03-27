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
@synthesize reachable;


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
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//        self.navigationItem.leftBarButtonItem.enabled = NO;
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkRechability];
    
    self.quoteText.backgroundColor = [UIColor clearColor];
    self.authorText.backgroundColor = [UIColor clearColor];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveQuote{
    
//    [self checkRechability];
    reachable = true;
    if (reachable == true) {
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
            
            
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"New Post", @"alert",
                                  nil];
            PFPush *push = [[PFPush alloc] init];
            [push setChannels:[NSArray arrayWithObjects:@"updates", nil]];
            [push setData:data];
            [push sendPushInBackground];
            
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
    } else{
        [self alertShow];
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
