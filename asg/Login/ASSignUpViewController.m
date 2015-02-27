//
//  ASSignUpViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASSignUpViewController.h"
#import "ASSignupDetailsTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <DTAlertView/DTAlertView.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "Global.h"

@interface ASSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressText;

@end

@implementation ASSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.pod 'DTAlertView'
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)checkEmailIsAlreadyInUseAndProceed:(NSString *)emailString {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD HUDForView:self.view].labelText = @"Checking email address";
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:emailString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (objects.count <= 0) {
            [self transitionSignupDetailsViewController];
        } else {
            [[DTAlertView alertViewWithTitle:@"User Exists" message:@"The email address is already in use" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        }
    }];
}

- (void)transitionSignupDetailsViewController {
    ASSignupDetailsTableViewController *tableViewController = (ASSignupDetailsTableViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_SIGNUP_DETAILS_VC_IDENTIFIER];
    tableViewController.emailAddress = self.emailAddressText.text;
    [self.navigationController pushViewController:tableViewController animated:YES];

}

#pragma mark - Actions

- (IBAction)didTapRegisterButton:(id)sender {
    if ([Global isValidEmailString:self.emailAddressText.text]) {
        [self checkEmailIsAlreadyInUseAndProceed:self.emailAddressText.text];
    } else {
        [[DTAlertView alertViewWithTitle:@"Invalid" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
    }
}

@end
