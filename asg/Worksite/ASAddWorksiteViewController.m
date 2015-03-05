//
//  ASAddWorksiteViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 3/3/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASAddWorksiteViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <DTAlertView/DTAlertView.h>
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import "WorkSite.h"
#import <Parse/Parse.h>

@interface ASAddWorksiteViewController () <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *siteCodeText;
@property (weak, nonatomic) IBOutlet UITextField *siteNameText;
@property (weak, nonatomic) IBOutlet UITextField *siteAddressText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@end

@implementation ASAddWorksiteViewController {
    UIImagePickerController *imagePicker;
    UIImage *selectedImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePicker.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.worksite) {
        self.siteAddressText.text = [self.worksite objectForKey:@"address"];
        self.siteNameText.text = [self.worksite objectForKey:@"name"];
        self.siteCodeText.text = [self.worksite objectForKey:@"code"];
        self.descriptionText.text = [self.worksite objectForKey:@"description"];
        if ([self.worksite objectForKey:@"image"]) {
            self.imageView.image = [UIImage imageWithData:[[self.worksite objectForKey:@"image"] getData]];
        }
}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (BOOL)areAllFieldsValid {
    if (self.siteNameText.text.length != 0 && self.siteAddressText.text.length != 0 && self.descriptionText.text.length != 0 && self.siteCodeText.text.length != 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Actions

- (IBAction)didTapCameraButton:(id)sender {
    
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

- (IBAction)didTapSaveBarButton:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD HUDForView:self.view].labelText = @"Saving Worksite";
    
    if ([self areAllFieldsValid]) {
        WorkSite *worksite = [[WorkSite alloc] init];
        worksite.name = self.siteNameText.text;
        worksite.code = @([self.siteCodeText.text integerValue]);
        worksite.address = self.siteAddressText.text;
        worksite.description = self.descriptionText.text;
        worksite.user = [PFUser currentUser];
        
        if (selectedImage) {
            NSData *imageData = UIImagePNGRepresentation(selectedImage);
            worksite.image = [PFFile fileWithName:@"Site.png" data:imageData];
        }
        
        [worksite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                if (succeeded) {
                    [[DTAlertView alertViewUseBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } title:@"Success" message:@"You have added a new worksite." cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                } else {
                    [[DTAlertView alertViewWithTitle:@"Error" message:@"An unexpected error occured. Please try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                }
                
                [worksite saveInBackground];
            } else {
                [[DTAlertView alertViewWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
        }];
    } else {
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        selectedImage = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = selectedImage;
    }];
}


@end
