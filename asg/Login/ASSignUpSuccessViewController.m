//
//  ASSignUpSuccessViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASSignUpSuccessViewController.h"
#import <Parse/Parse.h>

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
    
}

@end
