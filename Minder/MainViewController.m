//
//  MainViewController.m
//  Minder
//
//  Created by Derek Bertubin on 3/5/14.
//  Copyright (c) 2014 Derek Bertubin. All rights reserved.
//

#import "MainViewController.h"
#import "Reachability.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize quotes;
@synthesize currentUser;
@synthesize postedByLabel;
@synthesize quoteLabel;
@synthesize reachable;
@synthesize networkAlert;
@synthesize query = _query;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self checkRechability];
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                            init];
        self.refreshControl = refreshControl;
        
        [refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
        [self setRefreshControl:refreshControl];
        
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
        [self reloadTable];
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        
        NSLog(@"UNREACHABLE!");
        reachable = false;
        //        self.navigationItem.rightBarButtonItem.enabled = NO;
        //        self.navigationItem.leftBarButtonItem.enabled = NO;
        //        if (self.refreshControl.isRefreshing) {
        //
        //        }
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkRechability];
    [self startPolling];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    self.refreshControl = refreshControl;
    
    
    [refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    

    // Uncomment the following line to preserve selection between presentations.
    //     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkRechability];
    [self reloadTable];
    
}

- (void)reloadTable
{
    
    //    if (reachable == true) {
    [self parseQuery];
    [self.tableView reloadData];
    //    } else {
    //        [self.tableView reloadData];
    //    }
    
    if (self.refreshControl.isRefreshing) {
        NSLog(@"Is refreshing");
        [self.refreshControl endRefreshing];
        NSLog(@"Stopped refreshing");
    }
    //    }else {
    //        [self alertShow];
    //        if (self.refreshControl.isRefreshing) {
    //            NSLog(@"Is refreshing");
    //            [self.refreshControl endRefreshing];
    //            NSLog(@"Stopped refreshing");
    //        }
    //    }
    
}

#pragma mark - Parse Stuff

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (reachable == true) {
        [self reloadTable];
        
        if (![PFUser currentUser]) { // No user logged in
            // Create the log in view controller
            PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
            [logInViewController setDelegate:self]; // Set ourselves as the delegate
            
            
            // Create the sign up view controller
            PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
            [signUpViewController setDelegate:self]; // Set ourselves as the delegate
            
            // Assign our sign up controller to be displayed from the login controller
            [logInViewController setSignUpController:signUpViewController];
            
            // Present the log in view controller
            [self presentViewController:logInViewController animated:YES completion:NULL];
        }
        
    } else{
        
    }
    
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Anonymous login failed.");
        } else {
            NSLog(@"Anonymous user logged in.");
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - Parse Query
-(void)parseQuery;
{
    _query = [PFQuery queryWithClassName:@"Quote"];
    _query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [_query orderByAscending:@"updatedAt"];
    [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray * holderForReverseOrder = [[NSMutableArray alloc] init];
        holderForReverseOrder = (NSMutableArray*)objects;
        quotes = (NSMutableArray*)[[holderForReverseOrder reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
        
    }];
    
    
    NSLog(@"%lu", (unsigned long)[quotes count]);
}

    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return quotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    currentUser = [PFUser currentUser];
    
    
    cell.quoteLabel.text = [[quotes valueForKey:@"quote"]objectAtIndex:indexPath.row];
    cell.postedByLabel.text = [[quotes valueForKey:@"username"]objectAtIndex:indexPath.row];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

#pragma mark - DELETE
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self checkRechability];
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        PFObject *quoteToDelete = [_query getObjectWithId:[[quotes objectAtIndex:indexPath.row]valueForKey:@"objectId"]];
        
        if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
            [[[UIAlertView alloc] initWithTitle:@"Ooops!"
                                        message:@"Sorry you must be logged in to delete a post!"
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
            [self reloadTable];
        }else{
            
            if (reachable) {
                NSLog(@"Reachable");
                [quotes removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [quoteToDelete deleteInBackground];
                [self reloadTable];
                
            } else {
                [quoteToDelete deleteEventually];
                [quotes removeObjectAtIndex:indexPath.row];
                
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
            
        }
        
    }else{
        [self alertShow];
    }
}

#pragma mark -TIMER FOR POLLING
- (void) startPolling {
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) tick:(NSTimer *) timer {
    //do something here..
    PFQuery * queryCheck = [PFQuery queryWithClassName:@"Quote"];
    queryCheck.cachePolicy = kPFCachePolicyIgnoreCache;
    [queryCheck findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > quotes.count) {
            [self reloadTable];
            NSLog(@"Test this out");
        }
    }];
    
   }



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDetails"]) {
        DetailViewController * detailView = (DetailViewController *)[segue destinationViewController];
        detailView.quoteString = [[quotes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]]valueForKey:@"quote"];
        detailView.authorString = [[quotes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]]valueForKey:@"author"];
        detailView.userNameString = [[quotes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]]valueForKey:@"username"];
        detailView.postID = [[quotes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]]valueForKey:@"objectId"];
    }
}






@end
