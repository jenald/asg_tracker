//
//  ASResetPasswordViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 3/9/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASResetPasswordViewController.h"
#import "Global.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <DTAlertView/DTAlertView.h>
#import "ASLoginViewController.h"


@interface ASResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressText;

@end

@implementation ASResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)requestResetPassword:(id)sender {
    if ([Global isValidEmailString:self.emailAddressText.text]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [PFUser requestPasswordResetForEmailInBackground:[self.emailAddressText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] block:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!error) {
                if (succeeded) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[DTAlertView alertViewWithTitle:@"Success" message:@"We have sent an email on how to reset your password." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                    }];
                } else {
                    [[DTAlertView alertViewWithTitle:@"Failed" message:@"An unexpected error has occured. Please try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                }
            } else {
                [[DTAlertView alertViewWithTitle:@"Request Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
        }];
    } else {
        [[DTAlertView alertViewWithTitle:@"Incorrect" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
    }
}


@end
