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

@interface ASCheckInOutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *workAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *workSiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *timeStatusView;
@property (weak, nonatomic) IBOutlet UIButton *checkInOutButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation ASCheckInOutViewController {
    BOOL isCheckedIn;
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
    [self checkUserTimeInStatus];
}

#pragma mark - Private Methods

- (void)checkUserTimeInStatus {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [Timelog query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"checkOutTime" equalTo:[NSNull null]];
    [query includeKey:@"workSite"];
    [query includeKey:@"workArea"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            if (objects.count > 0) {
                Timelog *timelogDetails = (Timelog *)[objects firstObject];
                WorkArea *workArea = (WorkArea *)timelogDetails[@"workArea"];
                WorkSite *workSite = (WorkSite *)timelogDetails[@"workSite"];
                self.workAreaLabel.text = workArea[@"name"];
                self.workSiteLabel.text = workSite[@"name"];
                self.timeStatusView.backgroundColor = [UIColor greenColor];
                self.dateLabel.text = [self getMonthDayYearForDate:timelogDetails[@"checkInTime"]];
                self.timeLabel.text = [self getTimeForDate:timelogDetails[@"checkInTime"]];
                isCheckedIn = YES;
                [self.checkInOutButton setTitle:@"Check-Out" forState:UIControlStateNormal];
                self.title = @"Check-Out";
            } else {
                self.timeStatusView.backgroundColor = [UIColor redColor];
                isCheckedIn = NO;
                [self.checkInOutButton setTitle:@"Check-In" forState:UIControlStateNormal];
                self.title = @"Check-In";
            }
        } else {
            
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
}


@end
