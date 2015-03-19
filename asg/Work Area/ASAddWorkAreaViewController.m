//
//  ASAddWorkAreaViewController.m
//  asg
//
//  Created by Rey Jenald Pena on 3/12/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASAddWorkAreaViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <DTAlertView/DTAlertView.h>
#import "WorkArea.h"
#import "WorkSite.h"

@interface ASAddWorkAreaViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *areaCodeText;
@property (weak, nonatomic) IBOutlet UITextField *areaNameText;
@property (weak, nonatomic) IBOutlet UITextField *areaAddressText;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;

@end

@implementation ASAddWorkAreaViewController {
    UIImage *selectedImage;
}

@synthesize imagePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.workarea) {
        self.areaNameText.text = [self.workarea objectForKey:@"name"];
        self.areaCodeText.text = [self.workarea objectForKey:@"code"];
        
        if ([[self.workarea objectForKey:@"status"] boolValue]) {
            [self.statusSwitch setOn:YES];
            self.statusLabel.text = @"Active";
        } else {
            [self.statusSwitch setOn:NO];
            self.statusLabel.text = @"Inactive";
        }
        self.areaAddressText.text = [self.workarea objectForKey:@"address"];

        if ([self.workarea objectForKey:@"image"]) {
            self.imageView.image = [UIImage imageWithData:[[self.workarea objectForKey:@"image"] getData]];
        }
        self.navigationItem.title = [self.workarea objectForKey:@"name"];
    } else {
        self.navigationItem.title = @"Update Work Area";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (BOOL)areAllFieldsValid {
    if (self.areaNameText.text.length != 0 && self.areaAddressText.text.length != 0) {
        return YES;
    }
    
    return NO;
}

- (void)saveOrUpdateWorksite:(WorkArea *)workarea isForUpdate:(BOOL)isForUpdate {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD HUDForView:self.view].labelText = @"Saving Work Area";
    
    [workarea saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (succeeded) {
                if(isForUpdate) {
                    [[DTAlertView alertViewUseBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } title:@"Success" message:@"You have successfully updated the work area." cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                } else {
                    [[DTAlertView alertViewUseBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } title:@"Success" message:@"You have added a new work area." cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                }
            } else {
                [[DTAlertView alertViewWithTitle:@"Error" message:@"An unexpected error occured. Please try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
            
            [workarea saveInBackground];
        } else {
            [[DTAlertView alertViewWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        }
    }];
    
}

#pragma mark - Actions
- (IBAction)statusSwitchValueDidChange:(id)sender {
    UISwitch *statusSwitch = (UISwitch *)sender;
    if (statusSwitch.isOn) {
        self.statusLabel.text = @"Active";
    } else {
        self.statusLabel.text = @"Inactive";
    }
}

- (IBAction)didTapImageButton:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select Manager" rows:@[@"Take Photo",@"Photo Library"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if (selectedIndex == 0) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else if (selectedIndex == 1) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (IBAction)didTapSaveButton:(id)sender {
    if ([self areAllFieldsValid]) {
        if (self.workarea) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [MBProgressHUD HUDForView:self.view].labelText = @"Updating Work Area";
            PFQuery *query = [WorkArea query];
            [query whereKey:@"objectId" equalTo:self.workarea.objectId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(!error) {
                    if(objects.count > 0) {
                        WorkArea *worksite = (WorkArea *)[objects firstObject];
                        [worksite setObject:self.areaNameText.text forKey:@"name"];
                        [worksite setObject:self.areaCodeText.text forKey:@"code"];
                        [worksite setObject:self.areaAddressText.text forKey:@"address"];
                        [worksite setObject:@(self.statusSwitch.isOn) forKey:@"status"];
                        
                        if (selectedImage) {
                            CGSize newSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
                            UIGraphicsBeginImageContext(newSize);
                            [selectedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            NSData *imageData = UIImagePNGRepresentation(newImage);
                            [worksite setObject:[PFFile fileWithName:@"Area.png" data:imageData] forKey:@"image"];
                        }
                        
                        [self saveOrUpdateWorksite:worksite isForUpdate:YES];
                        
                    } else {
                        [[DTAlertView alertViewWithTitle:@"Error" message:@"An unexpected error occured. Please try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                    }
                } else {
                    [[DTAlertView alertViewWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                }
            }];

        } else {
            WorkArea *workarea = [[WorkArea alloc] init];
            
            workarea.name = self.areaNameText.text;
            workarea.code = self.areaCodeText.text;
            workarea.address = self.areaAddressText.text;
            workarea.status = self.statusSwitch.isOn;
            workarea.worksite = self.worksite;
            
            if (selectedImage) {
                CGSize newSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
                UIGraphicsBeginImageContext(newSize);
                [selectedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                NSData *imageData = UIImagePNGRepresentation(newImage);
                workarea.image = [PFFile fileWithName:@"Area.png" data:imageData];
            }
            [self saveOrUpdateWorksite:workarea isForUpdate:NO];
        }
        
    } else {
        [[DTAlertView alertViewWithTitle:@"Invalid" message:@"Please fill up all fields" delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
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

@end
