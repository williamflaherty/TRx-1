//
//  TRPatientListViewController.m
//  TRx
//
//  Created by Mark Bellott on 9/11/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import "TRPatientListViewController.h"
#import "TRPatientListCell.h"
#import "TRAddPatientViewController.h"
#import "TRTabBarController.h"

@interface TRPatientListViewController (){
    CGSize winSize;
}
@end

@implementation TRPatientListViewController{
    UITableView *_patientListTableView;
    UIBarButtonItem *_refreshPatientListButton;
    UIBarButtonItem *_addPatientButton;
}

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
    [self resizeViewsForOrientation:self.interfaceOrientation];
    
}
     
- (void)initialSetup{
    [self loadConstants];
    [self loadBarButtonItems];
    [self loadTableView];
}

- (void)loadConstants{
    winSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void) loadBarButtonItems{
    _refreshPatientListButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPatientList:)];
    self.navigationItem.leftBarButtonItem = _refreshPatientListButton;
    
    _addPatientButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Patient" style:UIBarButtonItemStylePlain target:self action:@selector(addNewPatient:)];
    self.navigationItem.rightBarButtonItem = _addPatientButton;
    
    self.navigationItem.title = @"Patient List";
}

- (void) loadTableView{
    _patientListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
    _patientListTableView.dataSource = self;
    _patientListTableView.delegate = self;
    [self.view addSubview:_patientListTableView];
}

#pragma mark - Bar Button Actions

- (void)refreshPatientList:(id)sender{
    NSLog(@"Refresh Patient List Pressed");
}

- (void)addNewPatient:(id)sender{
    NSLog(@"Add New Patient Pressed");
    
    TRAddPatientViewController *addPatientVC = [[TRAddPatientViewController alloc]init];
    NSLog(@"HELLO");
    [self.navigationController pushViewController:addPatientVC animated:YES];
}

#pragma mark - UITableViewDelegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TRPatientListCell *cell = (TRPatientListCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    TRTabBarController *patientTC = [[TRTabBarController alloc] init];
    [self.navigationController pushViewController:patientTC animated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180.0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"patientListCell";
    TRPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[TRPatientListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setUpCellItems];
    cell.patientCellPhoto.image = [UIImage imageNamed:@"Thumb.jpg"];
    cell.patientCellName.text = @"Mark Bellott";
    cell.patientCellComplaint.text = @"Complaint:";
    cell.patientCellBirthdate.text = @"Birthdate:";
    
    return cell;
}

#pragma mark - Orientation Handling Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewsForOrientation:toInterfaceOrientation];
}

- (void)resizeViewsForOrientation:(UIInterfaceOrientation)newOrientation{
    if(newOrientation == UIInterfaceOrientationPortrait
       || newOrientation == UIInterfaceOrientationPortraitUpsideDown){
        [self resizeFramesForPortrait];
    }
    else if(newOrientation == UIInterfaceOrientationLandscapeLeft
       || newOrientation == UIInterfaceOrientationLandscapeRight){
        [self resizeFramesForLandscape];
    }
    else{
        NSLog(@"Unsupported Orientation Switch: %d", newOrientation);
    }
}

- (void)resizeFramesForPortrait{
    _patientListTableView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
}

- (void)resizeFramesForLandscape{
    _patientListTableView.frame = CGRectMake(0, 0, winSize.height, winSize.width);
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
