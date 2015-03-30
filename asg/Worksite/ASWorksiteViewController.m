//
//  ASWorksiteViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/25/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASWorksiteViewController.h"
#import <Parse/Parse.h>
#import "WorkSite.h"
#import <DTAlertView/DTAlertView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Constants.h"
#import "Global.h"
#import "UserInfo.h"
#import "Position.h"
#import "ASDetailsWorksiteViewController.h"
#import "ASLoginViewController.h"

@interface ASWorksiteViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) ASDetailsWorksiteViewController *detaitsViewController;

@end

@implementation ASWorksiteViewController {
    NSArray *worksites;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[Global sharedInstance] isManager]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self fetchCurrentUserWorksites];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)fetchCurrentUserWorksites {
    PFQuery *worksitesQuery = [WorkSite query];
    [worksitesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects) {
                worksites = [NSArray arrayWithArray:objects];
                [self.tableView reloadData];
            } else {
//                [[DTAlertView alertViewWithTitle:nil message:@"No worksites found. Please add a worksite" delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
        } else {
            [[DTAlertView alertViewWithTitle:@"Request Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        }
    }];
}

- (void)deleteWorksite:(WorkSite *)worksite {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD HUDForView:self.view].labelText = @"Removing Worksite..";
    [worksite deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error && succeeded) {
            [[DTAlertView alertViewWithTitle:@"Success" message:@"You have successfully deleted a worksite" delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            [self fetchCurrentUserWorksites];
        } else {
            [[DTAlertView alertViewWithTitle:@"Failed" message:@"An unexpected error occured. Please check your network connection and try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        }
    }];
}

#pragma mark - Actions

- (IBAction)didTapLogoutButton:(id)sender {
    [[DTAlertView alertViewUseBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
        if (buttonIndex == 1) {
            ASLoginViewController *loginViewController = (ASLoginViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_LOGIN_VC_IDENTIFIER];
            [self presentViewController:loginViewController animated:YES completion:^{
                [PFUser logOut];
            }];
        }
    } title:@"Logout" message:@"Are you sure you want to logout?" cancelButtonTitle:@"No" positiveButtonTitle:@"Yes"] show];
}

- (IBAction)segmentControlValueDidChange:(id)sender {
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            
        }
            break;
        case 1: {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return worksites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WorksiteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WorkSite *worksite = (WorkSite *)worksites[indexPath.row];
    cell.textLabel.text = [worksite objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkSite *worksite = (WorkSite *)worksites[indexPath.row];
    self.detaitsViewController = (ASDetailsWorksiteViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_WORKSITE_DETAILS_VC_IDENTIFIER];
    self.detaitsViewController.worksite = worksite;
    [self.navigationController pushViewController:self.detaitsViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteWorksite:worksites[indexPath.row]];
    }
}

@end
