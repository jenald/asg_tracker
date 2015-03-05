//
//  ASDetailsWorksiteViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 3/4/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASDetailsWorksiteViewController.h"
#import "ASAddWorksiteViewController.h"
#import "Constants.h"
#import "Global.h"
#import "WorkSite.h"

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
    self.siteCodeLabel.text = [[self.worksite objectForKey:@"code"] stringValue];
    self.siteNameLabel.text = [self.worksite objectForKey:@"name"];
    self.siteDescriptionText.text = [self.worksite objectForKey:@"description"];
    if ([self.worksite objectForKey:@"image"]) {
        self.imageView.image = [UIImage imageWithData:[[self.worksite objectForKey:@"image"] getData]];
    }
}

#pragma mark - Actions

- (IBAction)didTapEditButton:(id)sender {
    ASAddWorksiteViewController *worksiteViewController = (ASAddWorksiteViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ADDWORKSITE_VC_IDENTIFIER];
    worksiteViewController.worksite = self.worksite;
    [self.navigationController pushViewController:worksiteViewController animated:YES];
}

- (IBAction)didTapWorkAreaButton:(id)sender {
    
}

@end
