//
//  ASCheckInOutViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 3/26/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASCheckInOutViewController.h"
#import <Parse/Parse.h>
#import "Timelog.h"
#import "WorkArea.h"
#import "WorkSite.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <DTAlertView/DTAlertView.h>
#import "Global.h"

@interface ASCheckInOutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *workAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *workSiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *timeStatusView;
@property (weak, nonatomic) IBOutlet UIButton *checkInOutButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation ASCheckInOutViewController {
    Timelog *loggedTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeStatusView.layer.cornerRadius = self.timeStatusView.frame.size.width/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.workAreaLabel.text = @"Work Area Name";
    self.workAreaLabel.textColor = [UIColor grayColor];
    self.workSiteLabel.text = @"Work Site Name";
    self.workSiteLabel.textColor = [UIColor grayColor];
    self.dateLabel.text = @"Time in Date";
    self.dateLabel.textColor = [UIColor grayColor];
    self.timeLabel.text = @"00:00:00";
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeStatusView.backgroundColor = [UIColor redColor];
    [self checkUserTimeInStatus];
}

#pragma mark - Private Methods

- (void)checkUserTimeInStatus {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    PFQuery *query = [Timelog query];
//    [query whereKey:@"user" equalTo:[PFUser currentUser]];
//    [query whereKey:@"checkOutTime" equalTo:[NSNull null]];
//    [query includeKey:@"workSite"];
//    [query includeKey:@"workArea"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        if (!error) {
//            if (objects.count > 0) {
//                loggedTime = (Timelog *)[objects firstObject];
//                WorkArea *workArea = (WorkArea *)loggedTime[@"workArea"];
//                WorkSite *workSite = (WorkSite *)loggedTime[@"workSite"];
//                self.workAreaLabel.text = workArea[@"name"];
//                self.workSiteLabel.text = workSite[@"name"];
//                self.timeStatusView.backgroundColor = [UIColor greenColor];
//                self.dateLabel.text = [self getMonthDayYearForDate:loggedTime[@"checkInTime"]];
//                self.timeLabel.text = [self getTimeForDate:loggedTime[@"checkInTime"]];
//                self.workAreaLabel.textColor = [UIColor blackColor];
//                self.workSiteLabel.textColor = [UIColor blackColor];
//                self.dateLabel.textColor = [UIColor blackColor];
//                self.timeLabel.textColor = [UIColor blackColor];
//                self.timeStatusView.backgroundColor = [UIColor greenColor];
//                isCheckedIn = YES;
//                [self.checkInOutButton setTitle:@"Check-Out" forState:UIControlStateNormal];
//                self.title = @"Check-Out";
//            } else {
//                self.timeStatusView.backgroundColor = [UIColor redColor];
//                isCheckedIn = NO;
//                [self.checkInOutButton setTitle:@"Check-In" forState:UIControlStateNormal];
//                self.title = @"Check-In";
//            }
//        } else {
//            
//        }
//    }];
    
    if ([[Global sharedInstance] isCheckedIn]) {
        loggedTime = [[Global sharedInstance] timelog];
        WorkArea *workArea = (WorkArea *)loggedTime[@"workArea"];
        WorkSite *workSite = (WorkSite *)loggedTime[@"workSite"];
        self.workAreaLabel.text = workArea[@"name"];
        self.workSiteLabel.text = workSite[@"name"];
        self.timeStatusView.backgroundColor = [UIColor greenColor];
        self.dateLabel.text = [self getMonthDayYearForDate:loggedTime[@"checkInTime"]];
        self.timeLabel.text = [self getTimeForDate:loggedTime[@"checkInTime"]];
        self.workAreaLabel.textColor = [UIColor blackColor];
        self.workSiteLabel.textColor = [UIColor blackColor];
        self.dateLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeStatusView.backgroundColor = [UIColor greenColor];
        [self.checkInOutButton setTitle:@"Check-Out" forState:UIControlStateNormal];
        self.title = @"Check-Out";
    } else {
        self.timeStatusView.backgroundColor = [UIColor redColor];
        [self.checkInOutButton setTitle:@"Check-In" forState:UIControlStateNormal];
        self.title = @"Check-In";
    }

}

- (void)checkOutUser {
    // TO DO : Check-in Functionality
    loggedTime[@"checkOutTime"] = [NSDate date];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [loggedTime saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error && succeeded) {
            self.navigationController.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[DTAlertView alertViewWithTitle:@"Success" message:@"You have successfully timed out." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            self.workAreaLabel.text = @"Work Area Name";
            self.workAreaLabel.textColor = [UIColor grayColor];
            self.workSiteLabel.text = @"Work Site Name";
            self.workSiteLabel.textColor = [UIColor grayColor];
            self.dateLabel.text = @"Time in Date";
            self.dateLabel.textColor = [UIColor grayColor];
            self.timeLabel.text = @"00:00:00";
            self.timeLabel.textColor = [UIColor grayColor];
            self.timeStatusView.backgroundColor = [UIColor redColor];
            [[Global sharedInstance] setIsCheckedIn:NO];
        } else {
            [[DTAlertView alertViewWithTitle:@"Time out failed" message:@"An unexpected error occured. Please check your network and try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        }
    }];

}

- (NSString *)getMonthDayYearForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, YYYY EEEE"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
}

- (NSString *)getTimeForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss a"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
}

#pragma mark - Actions

- (IBAction)didTapCheckInOutButton:(id)sender {
    // TO DO: Check In and Out Functionality
    if ([[Global sharedInstance] isCheckedIn]) {
        [self checkOutUser];
    } else {
        [[DTAlertView alertViewWithTitle:nil message:@"Please select a work site and work area to time in." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        self.tabBarController.selectedIndex = 0;
    }
}


@end
