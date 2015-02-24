//
//  ASLoginViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASLoginViewController.h"
#import "ASSignUpViewController.h"
#import "Global.h"
#import "Constants.h"

@interface ASLoginViewController ()

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

#pragma mark - Actions

- (IBAction)didTapRegisterButton:(id)sender {
    ASSignUpViewController *controller =  (ASSignUpViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_SIGNUP_VC_IDENTIFIER];
    
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationViewController animated:YES completion:nil];
    
}

@end
