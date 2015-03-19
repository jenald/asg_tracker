//
//  ASWorkAreasViewController.m
//  asg
//
//  Created by Rey Jenald Pena on 3/12/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASWorkAreasViewController.h"
#import "WorkSite.h"
#import "WorkArea.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <DTAlertView/DTAlertView.h>
#import "ASAddWorkAreaViewController.h"
#import "ASDetailsWorkAreaViewController.h"
#import "Global.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface ASWorkAreasViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ASWorkAreasViewController {
    NSArray *workAreas;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchWorkAreas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)fetchWorkAreas {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFQuery *workAreaQuery = [WorkArea query];
    [workAreaQuery whereKey:@"worksite" equalTo:self.worksite];
    [workAreaQuery includeKey:@"worksite"];
    [workAreaQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            if (objects.count > 0) {
                workAreas = [[NSArray alloc] initWithArray:objects];
                [self.tableView reloadData];
            } else {
//                [[DTAlertView alertViewWithTitle:nil message:@"No work areas found. Please add a work area" delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
        } else {
            [[DTAlertView alertViewWithTitle:@"Request Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        }
    }];
}

#pragma mark - Actions

- (IBAction)didTapAddButton:(id)sender {
    ASAddWorkAreaViewController *addWorkAreaViewController = (ASAddWorkAreaViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ADD_WORKAREA_VC_IDENTIFIER];
    addWorkAreaViewController.worksite = self.worksite;
    
    [self.navigationController pushViewController:addWorkAreaViewController animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return workAreas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WorkAreaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    WorkArea *workArea = workAreas[indexPath.row]
    ;
    
    cell.textLabel.text = [workArea objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASDetailsWorkAreaViewController *detailsWorkAreaViewController = (ASDetailsWorkAreaViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_WORKAREA_DETAILS_VC_IDENTIFIER];
    detailsWorkAreaViewController.workarea = workAreas[indexPath.row];
    detailsWorkAreaViewController.worksite = self.worksite;
    
    [self.navigationController pushViewController:detailsWorkAreaViewController animated:YES];
}

@end
