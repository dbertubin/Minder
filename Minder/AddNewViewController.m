//
//  AddNewViewController.m
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import "AddNewViewController.h"
#import <Parse/Parse.h>

@interface AddNewViewController ()

@end

@implementation AddNewViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveQuote{
    // We create a new Parse object and set the data we want to store
    PFObject *newQuote = [[PFObject alloc] initWithClassName:@"Quote"];
    
    [newQuote setObject: self.quoteText.text forKey:@"quote"];
    [newQuote setObject: self.authorText.text forKey:@"author"];
    
    // Create 1-1 relationship between the current user and the post
    [newQuote setObject:[PFUser currentUser] forKey:@"fromUser"];
    [newQuote saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(@"Object saved to Parse! :)");
    }];
}



- (IBAction)onSavedClicked:(UIButton *)sender {
    [self saveQuote];
    [ self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
