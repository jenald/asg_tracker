//
//  ASLoginViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASLoginViewController.h"
#import "ASSignUpViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <DTAlertView/DTAlertView.h>
#import "ASRootController.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "Global.h"
#import "ASResetPasswordViewController.h"

@interface ASLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation ASLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)loginWithUser:(PFUser *)user {
    [MBProgressHUD HUDForView:self.view].labelText = @"Veryfying User..";
    [PFUser logInWithUsernameInBackground:user.username password:self.passwordText.text block:^(PFUser *user, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error && user) {
            ASRootController *rootController = (ASRootController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ROOT_VC_IDENTIFIER];
            [self presentViewController:rootController animated:YES completion:nil];
        } else {
            [[[DTAlertView alloc]initWithTitle:@"Login Failed" message:@"Please check login credentials" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        }
    }];
}

#pragma mark - Actions

- (IBAction)didTapRegisterButton:(id)sender {
    ASSignUpViewController *controller =  (ASSignUpViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_SIGNUP_VC_IDENTIFIER];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationViewController animated:YES completion:nil];
    
}

- (IBAction)didTapLoginButton:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD HUDForView:self.view].labelText = @"Logging in..";
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:self.emailAddressText.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            PFUser *user = (PFUser *)[objects firstObject];
            [self loginWithUser:user];
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[DTAlertView alloc]initWithTitle:@"Login Failed" message:@"Please check login credentials" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        }
    }];
}

- (IBAction)didTapForgotPassword:(id)sender {
    
    ASResetPasswordViewController *resetPasswordVC = (ASResetPasswordViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_RESET_PASS_VC_IDENTIFIER];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resetPasswordVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
