//
//  ASSignupDetailsTableViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASSignupDetailsTableViewController.h"
#import "ASSignUpSuccessViewController.h"
#import "Global.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DTAlertView.h"
#import "ActionSheetStringPicker.h"
#import "UserInfo.h"
#import "Position.h"

@interface ASSignupDetailsTableViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *idNumberText;
@property (weak, nonatomic) IBOutlet UITextField *roleText;
@property (weak, nonatomic) IBOutlet UITextField *managerText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressText;

@end

@implementation ASSignupDetailsTableViewController {
    MBProgressHUD *hud;
    NSArray *positions;
    NSArray *managers;
    Position *selectedPosition;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.emailAddressText.text = self.emailAddress;
    
    PFQuery *positionQuery = [Position query];
    [positionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        positions = [NSArray arrayWithArray:objects];
    }];
    PFQuery *userInfoQuery = [UserInfo query];
    [userInfoQuery whereKey:@"position.positionId" equalTo:@"1"];
    [userInfoQuery includeKey:@"position"];
    
    [userInfoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        managers = [NSArray arrayWithArray:objects];
    }];
}

#pragma mark - Private Methods

- (void)saveUserInfoForUser:(PFUser *)user {
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.fullName = self.nameText.text;
    userInfo.idNumber = self.idNumberText.text;
    userInfo.phoneNumber = self.phoneNumberText.text;
    userInfo.user = user;
    userInfo.position = selectedPosition;
    
    [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (succeeded) {
            [self transitionToSignUpSuccessViewControllerWithUser:user];
        } else {
            [[DTAlertView alertViewWithTitle:@"Please check you network connection" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        }
    }];
}

- (void)transitionToSignUpSuccessViewControllerWithUser:(PFUser *)user {
    ASSignUpSuccessViewController *controller = (ASSignUpSuccessViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_SIGNUP_SUCCESS_VC_IDENTIFIER];
    controller.user = user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)allFieldsAreValid {
    if ((![self.passwordText.text isEqualToString:self.confirmPasswordText.text]) || self.passwordText.text.length <= 0 || self.confirmPasswordText.text.length <= 0) {
        [[DTAlertView alertViewWithTitle:@"Invalid" message:@"Password did not match" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        return NO;
    } else if (self.roleText.text.length <= 0) {
        [[DTAlertView alertViewWithTitle:@"Invalid" message:@"Please select a role" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        return NO;
    } else if (self.nameText.text.length <= 0) {
        [[DTAlertView alertViewWithTitle:@"Invalid" message:@"Please enter your Complete Name" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        return NO;
    } else if (self.idNumberText.text.length <= 0) {
        [[DTAlertView alertViewWithTitle:@"Invalid" message:@"Please enter your ID Number" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        return NO;
    } else if (self.emailAddressText.text.length <= 0 || ![Global isValidEmailString:self.emailAddressText.text]) {
        [[DTAlertView alertViewWithTitle:@"Invalid" message:@"Please enter a valid email address" delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
        return NO;
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)didTapRegisterButton:(id)sender {
    if ([self allFieldsAreValid]) {
        NSString *username = [self.nameText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        PFUser *user = [[PFUser alloc] init];
        user.username = [username lowercaseString];
        user.password = self.passwordText.text;
        user.email = self.emailAddressText.text;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MBProgressHUD HUDForView:self.view].labelText = @"Saving User ...";
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [MBProgressHUD HUDForView:self.view].labelText = @"Saving User Details ...";
                [self saveUserInfoForUser:user];
            } else {
                [[DTAlertView alertViewWithTitle:@"Please check you network connection" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" positiveButtonTitle:nil] show];
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.managerText]) {
        	
    } else if ([textField isEqual:self.roleText]) {
        NSArray *arrayOfRoles = [positions valueForKeyPath:@"name"];
        [ActionSheetStringPicker showPickerWithTitle:@"Select Role" rows:arrayOfRoles initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            selectedPosition = positions[selectedIndex];
            textField.text = arrayOfRoles[selectedIndex];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:textField];
        
    }
}

@end
