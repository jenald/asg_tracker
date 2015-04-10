//
//  ASAssetViewController.m
//  asg
//
//  Created by Rey Jenald Pena on 4/7/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASAssetViewController.h"
#import <DTAlertView/DTAlertView.h>
#import "ASLoginViewController.h"
#import "ASAddASsetViewController.h"
#import "Global.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "Asset.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ASAssetDetailsViewController.h"

@interface ASAssetViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ASAssetViewController {
    NSArray *assets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@""]
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchAssets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)fetchAssets {
    PFQuery *worksitesQuery = [Asset query];
    [worksitesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects) {
                assets = [NSArray arrayWithArray:objects];
                [self.tableView reloadData];
            } else {
                //                [[DTAlertView alertViewWithTitle:nil message:@"No worksites found. Please add a worksite" delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
        } else {
            [[DTAlertView alertViewWithTitle:@"Fetching Assets Failed" message:@"An unexpected error occured. Please check your network connection and try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        }
    }];
}

- (void)deleteAsset:(Asset *)asset {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD HUDForView:self.view].labelText = @"Removing Asset..";
    [asset deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error && succeeded) {
            [[DTAlertView alertViewWithTitle:@"Success" message:@"You have successfully deleted an asset" delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            [self fetchAssets];
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

- (IBAction)didTapAddAssetButton:(id)sender {
    ASAddASsetViewController *addAssetViewController = (ASAddASsetViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ADD_ASSET_VC_IDENTIFIER];
    [self.navigationController pushViewController:addAssetViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return assets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AssetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Asset *asset = assets[indexPath.row];
    cell.textLabel.text = asset[@"model"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Asset *asset = assets[indexPath.row];
    ASAssetDetailsViewController *assetDetailsViewController = (ASAssetDetailsViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ASSET_DETAILS_VC_IDENTIFIER];
    assetDetailsViewController.asset = asset;
    [self.navigationController pushViewController:assetDetailsViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAsset:assets[indexPath.row]];
    }
}

@end
