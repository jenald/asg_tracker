//
//  ASDetailsWorkAreaViewController.m
//  asg
//
//  Created by Rey Jenald Pena on 3/13/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASDetailsWorkAreaViewController.h"
#import "ASAddWorkAreaViewController.h"
#import "Global.h"
#import "Constants.h"
#import "WorkArea.h"
#import "WorkSite.h"

@interface ASDetailsWorkAreaViewController ()
@property (weak, nonatomic) IBOutlet UILabel *areaIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ASDetailsWorkAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[Global sharedInstance] isManager]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    PFQuery *query = [WorkArea query];
    [query whereKey:@"objectId" equalTo:self.workarea.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if(objects.count >0) {
                WorkArea *workArea = (WorkArea *)[objects firstObject];
                self.areaIDLabel.text = [workArea objectForKey:@"name"];
                self.areaCodeLabel.text = [workArea objectForKey:@"code"];
                self.areaStatusLabel.text = ([[workArea objectForKey:@"status"] boolValue] ? @"Active" : @"Inactive" );
                
                self.siteIDLabel.text = [self.worksite objectForKey:@"name"];
                
                if ([workArea objectForKey:@"image"]) {
                    self.imageView.image = [UIImage imageWithData:[[workArea objectForKey:@"image"] getData]];
                }
                self.navigationItem.title = [workArea objectForKey:@"name"];
            } else {
                // TO DO: Handle if worksite is not found on database
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didTapCheckInButton:(id)sender {
    // TO DO : Check-in Functionality
}

- (IBAction)didTapEditButton:(id)sender {
    ASAddWorkAreaViewController *updateWorkAreaViewController = (ASAddWorkAreaViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ADD_WORKAREA_VC_IDENTIFIER];
    updateWorkAreaViewController.workarea = self.workarea;
    
    [self.navigationController pushViewController:updateWorkAreaViewController animated:YES];
}

@end
