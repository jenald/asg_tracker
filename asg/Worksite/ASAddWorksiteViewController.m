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

@interface ASAddWorksiteViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *siteCodeText;
@property (weak, nonatomic) IBOutlet UITextField *siteNameText;
@property (weak, nonatomic) IBOutlet UITextField *siteAddressText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation ASAddWorksiteViewController {
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
    if (self.worksite) {
        self.navigationItem.title = @"Update Worksite";
        
        self.siteAddressText.text = [self.worksite objectForKey:@"address"];
        self.siteNameText.text = [self.worksite objectForKey:@"name"];
        self.siteCodeText.text = [[self.worksite objectForKey:@"code"] stringValue];
        self.descriptionText.text = [self.worksite objectForKey:@"description"];
        if ([self.worksite objectForKey:@"image"]) {
            self.imageView.image = [UIImage imageWithData:[[self.worksite objectForKey:@"image"] getData]];
        }
    } else {
        self.navigationItem.title = @"Add Worksite";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.worksite = nil;
}

#pragma mark - Private Methods

- (BOOL)areAllFieldsValid {
    if (self.siteNameText.text.length != 0 && self.siteAddressText.text.length != 0 && self.descriptionText.text.length != 0 && self.siteCodeText.text.length != 0) {
        return YES;
    }
    
    return NO;
}

- (void)saveOrUpdateWorksite:(WorkSite *)worksite isForUpdate:(BOOL)isForUpdate {
    [worksite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (succeeded) {
                if(isForUpdate) {
                    [[DTAlertView alertViewUseBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } title:@"Success" message:@"You have successfully updated the worksite." cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                } else {
                    [[DTAlertView alertViewUseBlock:^(DTAlertView *alertView, NSUInteger buttonIndex, NSUInteger cancelButtonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } title:@"Success" message:@"You have added a new worksite." cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
                }
            } else {
                [[DTAlertView alertViewWithTitle:@"Error" message:@"An unexpected error occured. Please try again." delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
            }
            
            [worksite saveInBackground];
        } else {
            [[DTAlertView alertViewWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
        }
    }];

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
        
        if(self.worksite) {
            PFQuery *query = [WorkSite query];
            [query whereKey:@"objectId" equalTo:self.worksite.objectId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error) {
                    if(objects.count > 0) {
                        WorkSite *worksite = (WorkSite *)[objects firstObject];
                        [worksite setObject:self.siteNameText.text forKey:@"name"];
                        [worksite setObject:@([self.siteCodeText.text integerValue]) forKey:@"code"];
                        [worksite setObject:self.siteAddressText.text forKey:@"address"];
                        [worksite setObject:self.descriptionText.text forKey:@"description"];

                        if (selectedImage) {
                            CGSize newSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
                            UIGraphicsBeginImageContext(newSize);
                            [selectedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            NSData *imageData = UIImagePNGRepresentation(newImage);
                            [worksite setObject:[PFFile fileWithName:@"Site.png" data:imageData] forKey:@"image"];
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
            WorkSite *worksite = [[WorkSite alloc] init];
            
            worksite.name = self.siteNameText.text;
            worksite.code = @([self.siteCodeText.text integerValue]);
            worksite.address = self.siteAddressText.text;
            worksite.description = self.descriptionText.text;
            worksite.user = [PFUser currentUser];
            
            if (selectedImage) {
                CGSize newSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
                UIGraphicsBeginImageContext(newSize);
                [selectedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                NSData *imageData = UIImagePNGRepresentation(newImage);
                worksite.image = [PFFile fileWithName:@"Site.png" data:imageData];
            }

            [self saveOrUpdateWorksite:worksite isForUpdate:NO];
        }
    } else {
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    selectedImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
