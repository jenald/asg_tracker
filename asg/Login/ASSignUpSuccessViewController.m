//
//  ASSignUpSuccessViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASSignUpSuccessViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "UserInfo.h"
#import "ASLoginViewController.h"
#import "Constants.h"
#import "Global.h"
#import <DTAlertView/DTAlertView.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ASSignUpSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *assignedUserIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *assignedUserNameLabel;

@end

@implementation ASSignUpSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.pod 'DTAlertView'
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.assignedUserIdLabel.text = self.user.objectId;
    self.assignedUserNameLabel.text = self.user.username;
}

#pragma mark - Actions

- (IBAction)didTapDoneButton:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD HUDForView:self.view].labelText = @"Validating Account";
    
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:self.user.objectId];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (objects.count > 0) {
            PFUser *userDetails = (PFUser *)[objects firstObject];
            if (![[userDetails objectForKey:@"emailVerified"] boolValue]) {
                [[DTAlertView alertViewUseBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
                    ASLoginViewController *loginVc = (ASLoginViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_LOGIN_VC_IDENTIFIER];
                    [self presentViewController:loginVc animated:YES completion:nil];
                } title:@"Email Verification" message:@"You have not yet verified your account. Please check your email and follow the verification process." cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
            } else {
                [PFUser logInWithUsernameInBackground:self.user.username password:self.user.password block:^(PFUser *user, NSError *error) {
                    if (!error) {
                        ASRootController *rootController = (ASRootController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ROOT_VC_IDENTIFIER];
                        [self presentViewController:rootController animated:YES completion:nil];
                    }
                }];
            }
        }
    }];
    
}

@end
