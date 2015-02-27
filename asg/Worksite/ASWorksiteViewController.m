//
//  ASWorksiteViewController.m
//  asg
//
//  Created by Rey Jenald Peña on 2/25/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "ASWorksiteViewController.h"

@interface ASWorksiteViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ASWorksiteViewController {
    NSArray *worksites;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupNavigationController {
    
}

#pragma mark - Private Methods

#pragma mark - Actions

- (IBAction)segmentControlValueDidChange:(id)sender {
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            
        }
            break;
        case 1: {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WorksiteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Worksite %d",indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate


@end
