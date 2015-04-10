//
//  ASAssetDetailsViewController.m
//  asg
//
//  Created by Rey Jenald Pena on 4/10/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASAssetDetailsViewController.h"
#import "Asset.h"
#import "Global.h"
#import <DTAlertView/DTAlertView.h>

@interface ASAssetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ASAssetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [Asset query];
    [query whereKey:@"objectId" equalTo:self.asset.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if(objects.count >0) {
                Asset *fetchedAsset = (Asset *)[objects firstObject];
                self.code.text = [fetchedAsset objectForKey:@"code"];
                self.name.text = [fetchedAsset objectForKey:@"name"];
                self.number.text = [fetchedAsset objectForKey:@"number"];
                self.status.text = [[fetchedAsset objectForKey:@"status"] boolValue] ? @"Active" : @"In-active";
                
                if ([self.asset objectForKey:@"image"]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        //Call your function or whatever work that needs to be done
                        //Code in this part is run on a background thread
                        UIImage *image = [UIImage imageWithData:[[fetchedAsset objectForKey:@"image"] getData]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            self.imageView.image = image;
                            
                            //Stop your activity indicator or anything else with the GUI
                            //Code here is run on the main thread
                            
                        });
                    });
                }
                self.navigationItem.title = [fetchedAsset objectForKey:@"name"];
            } else {
                // TO DO: Handle if asset is not found on database
            }
        }
    }];
    
}

#pragma mark - Actions

- (IBAction)didTapEditButton:(id)sender {
    [[[DTAlertView alloc] initWithTitle:@"On Going" message:@"Still in development. Please wait for the next build release. Thanks" delegate:nil cancelButtonTitle:nil positiveButtonTitle:@"Okay"] show];
}


@end
