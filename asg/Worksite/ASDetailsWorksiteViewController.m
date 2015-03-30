//
//  ASDetailsWorksiteViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 3/4/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASDetailsWorksiteViewController.h"
#import "ASAddWorksiteViewController.h"
#import "ASWorkAreasViewController.h"
#import "Constants.h"
#import "Global.h"
#import "WorkSite.h"
#import "UserInfo.h"
#import <Parse/Parse.h>

@interface ASDetailsWorksiteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteCodeLabel;
@property (weak, nonatomic) IBOutlet UITextView *siteDescriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ASDetailsWorksiteViewController

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
    
    if (![[Global sharedInstance] isManager]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    PFQuery *query = [WorkSite query];
    [query whereKey:@"objectId" equalTo:self.worksite.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if(objects.count >0) {
                WorkSite *worksite = (WorkSite *)[objects firstObject];
                self.siteCodeLabel.text = [worksite objectForKey:@"code"];
                self.siteNameLabel.text = [worksite objectForKey:@"name"];
                self.siteDescriptionText.text = [worksite objectForKey:@"description"];
                if ([self.worksite objectForKey:@"image"]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        //Call your function or whatever work that needs to be done
                        //Code in this part is run on a background thread
                        UIImage *image = [UIImage imageWithData:[[worksite objectForKey:@"image"] getData]];

                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            self.imageView.image = image;

                            //Stop your activity indicator or anything else with the GUI
                            //Code here is run on the main thread
                            
                        });
                    });
                }
                self.navigationItem.title = [worksite objectForKey:@"name"];
            } else {
                // TO DO: Handle if worksite is not found on database
            }
        }
    }];
   
}

#pragma mark - Actions

- (IBAction)didTapEditButton:(id)sender {
    ASAddWorksiteViewController *worksiteViewController = (ASAddWorksiteViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ADDWORKSITE_VC_IDENTIFIER];
    worksiteViewController.worksite = self.worksite;
    [self.navigationController pushViewController:worksiteViewController animated:YES];
}

- (IBAction)didTapWorkAreaButton:(id)sender {
    ASWorkAreasViewController *workArea = (ASWorkAreasViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_WORKAREA_VC_IDENTIFIER];
    workArea.worksite = self.worksite;
    [self.navigationController pushViewController:workArea animated:YES];
}

@end
