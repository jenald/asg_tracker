//
//  ASAddASsetViewController.m
//  asg
//
//  Created by Rey Jenald Pena on 4/7/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASAddASsetViewController.h"
#import "AddAssetTableViewCell.h"
#import "Asset.h"
#import <Parse/Parse.h>
#import <DTAlertView/DTAlertView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import "Global.h"
#import "NSDate+ASAdditions.h"
#import <ActionSheetStringPicker.h>
#import "IQUIView+Hierarchy.h"
#import "IQKeyboardManager.h"

@interface ASAddASsetViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavigationBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftNavigationBarItem;

@end

@implementation ASAddASsetViewController {
    NSArray *assetLabelsArray;
    NSArray *assetPlaceholderArray;
    NSMutableDictionary *assetDetails;
    UIImage *selectedImage;
    BOOL isOnAssetFinalDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    assetDetails = [[NSMutableDictionary alloc] init];
    isOnAssetFinalDetails = NO;
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"AddAssetCell" bundle:nil] forCellReuseIdentifier:@"AddAssetCell"];
    assetLabelsArray = @[@"Asset Model",
                         @"Asset Number",
                         @"Manufacturer",
                         @"Type",
                         @"Date Purchase",
                         @"Date Expiry",
                         @"Inspection Date"];
    assetPlaceholderArray = @[@"143223",
                              @"Asset Number",
                              @"Abc Company",
                              @"Tools",
                              @"December 21, 2015",
                              @"December 21, 2016",
                              @"December 21, 2015"];
}

#pragma mark - Actions
- (IBAction)didTapBackButton:(id)sender {
    if (isOnAssetFinalDetails) {
        self.rightNavigationBarItem.title = @"Next";
        self.leftNavigationBarItem.title = @"Assets";
        assetLabelsArray = @[@"Asset Model",
                             @"Asset Number",
                             @"Manufacturer",
                             @"Type",
                             @"Date Purchase",
                             @"Date Expiry",
                             @"Inspection Date"];
        assetPlaceholderArray = @[@"143223",
                                  @"Asset Number",
                                  @"Abc Company",
                                  @"Tools",
                                  @"December 21, 2015",
                                  @"December 21, 2016",
                                  @"December 21, 2015"];
        isOnAssetFinalDetails = NO;
        [self.tableView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)didTapAddImageButton:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select Manager" rows:@[@"Take Photo",@"Photo Library"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if (selectedIndex == 0) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } else if (selectedIndex == 1) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (IBAction)didTapSaveButton:(id)sender {
    if (!isOnAssetFinalDetails) {
        self.rightNavigationBarItem.title = @"Save";
        self.leftNavigationBarItem.title = @"Back";
        assetLabelsArray = @[@"Asset Code",
                             @"Asset Name",
                             @"Status"];
        assetPlaceholderArray = @[@"143223",
                                  @"Asset Name",
                                  @"In-active / Active"];
        isOnAssetFinalDetails = YES;
        [self.tableView reloadData];
    } else {
        Asset *asset = [[Asset alloc] init];
        asset.model = assetDetails[@"Asset Model"];
        asset.number = assetDetails[@"Asset Number"];
        asset.manufacturer = assetDetails[@"Manufacturer"];
        asset.type = assetDetails[@"Type"];
        asset.purchaseDate = assetDetails[@"Date Purchase"];
        asset.expiryDate = assetDetails[@"Date Expiry"];
        asset.inspectionDate = assetDetails[@"Inspection Date"];
        asset.code = assetDetails[@"Asset Code"];
        asset.name = assetDetails[@"Asset Name"];
        
        if ([assetDetails[@"Status"] isEqualToString:@"Active"]) {
            asset.status = YES;
        } else {
            asset.status = NO;
        }
        
        if (selectedImage) {
            CGSize newSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
            UIGraphicsBeginImageContext(newSize);
            [selectedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *imageData = UIImagePNGRepresentation(newImage);
            [asset setObject:[PFFile fileWithName:@"Asset.png" data:imageData] forKey:@"image"];
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MBProgressHUD HUDForView:self.view].labelText = @"Saving Assset";
        [asset saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!error) {
                if (succeeded) {
                    [[[DTAlertView alloc] initWithBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } title:@"Success" message:@"You have successfully added an asset" cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                }
            } else {
                [[[DTAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.isAskingCanBecomeFirstResponder == NO) {
        switch (textField.tag) {
            case 2: {
                if (!isOnAssetFinalDetails) { // Manufacturer
                    return YES;
                } else { // Status
                    [ActionSheetStringPicker showPickerWithTitle:@"Status" rows:@[@"Active",@"In-active"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                        textField.text = selectedValue;
                        [[IQKeyboardManager sharedManager] resignFirstResponder];
                    } cancelBlock:^(ActionSheetStringPicker *picker) {
                        [[IQKeyboardManager sharedManager] resignFirstResponder];
                    } origin:textField];
                    return NO;
                }
            }
                break;
            case 4: // Date Purchase
            case 5: // Date Expiry
            case 6: // Inspection Date
            {
                [ActionSheetDatePicker showPickerWithTitle:textField.accessibilityIdentifier datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                    assetDetails[textField.accessibilityIdentifier] = selectedDate;
                    textField.text = [(NSDate *)selectedDate stringWithDateFormat:@"MMM dd, YYYY"];
                    [[IQKeyboardManager sharedManager] resignFirstResponder];
                } cancelBlock:^(ActionSheetDatePicker *picker) {
                    [[IQKeyboardManager sharedManager] resignFirstResponder];
                } origin:self.view];
                return NO;
            }
                break;
            default:
                return YES;
                break;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Cell NAME: %@",textField.accessibilityIdentifier);
    NSLog(@"Dictionary: %@",assetDetails);
    
    switch (textField.tag) {
        case 4:
        case 5:
        case 6:{ // Inspection Date
        }
            break;
            
        default:
            assetDetails[textField.accessibilityIdentifier] = textField.text;
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedImage = info[UIImagePickerControllerOriginalImage];
        [self.imageView setImage:selectedImage];
        [self.imageView setNeedsDisplay];
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return assetLabelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"AddAssetCell";
    AddAssetTableViewCell *cell = (AddAssetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.assetTitleLabel.text = assetLabelsArray[indexPath.row];
    cell.assetTextField.placeholder = assetPlaceholderArray[indexPath.row];
    cell.assetTextField.tag = indexPath.row;
    cell.assetTextField.delegate = self;
    
    if (indexPath.row > 3) {
        cell.assetTextField.text = [assetDetails[assetLabelsArray[indexPath.row]] stringWithDateFormat:@"MMM dd, YYYY"];
    } else {
        cell.assetTextField.text = assetDetails[assetLabelsArray[indexPath.row]];
    }
    
    cell.assetTextField.accessibilityIdentifier = assetLabelsArray[indexPath.row];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.date = [NSDate date];
    switch (cell.tag) {
        case 4: // Date Purchase
        case 5: // Date Expiry
        case 6: // Inspection Date
            [cell.assetTextField setInputView:datePicker];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}

@end
