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
#import "TRSettingsViewController.h"
#import "TRTabBarController.h"
#import "TRManagedObjectContext.h"

@interface TRPatientListViewController (){
    CGSize winSize;
}

@property (nonatomic, strong) TRManagedObjectContext  *managedObjectContext;

@end

@implementation TRPatientListViewController{
    UIBarButtonItem *_settingsButton;
    UIBarButtonItem *_addPatientButton;
    
    UITableView *_patientListTableView;
    UIRefreshControl *_patientListRefreshControl;
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

- (void)viewWillAppear:(BOOL)animated{
    [self resizeViewsForOrientation:self.interfaceOrientation];
}
     
- (void)initialSetup{
    self.managedObjectContext = [TRManagedObjectContext mainThreadContext];
    [self loadConstants];
    [self loadBarButtonItems];
    [self loadTableView];
}

- (void)loadConstants{
    winSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void) loadBarButtonItems{
    _settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsPressed)];
    self.navigationItem.leftBarButtonItem = _settingsButton;
    
    _addPatientButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Patient" style:UIBarButtonItemStylePlain target:self action:@selector(addNewPatientPressed)];
    self.navigationItem.rightBarButtonItem = _addPatientButton;
    
    self.navigationItem.title = @"Patient List";
}

- (void) loadTableView{
    _patientListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
    _patientListTableView.dataSource = self;
    _patientListTableView.delegate = self;
    [self.view addSubview:_patientListTableView];
    
    _patientListRefreshControl = [[UIRefreshControl alloc] init];
    [_patientListRefreshControl addTarget:self action:@selector(handlePatientListRefresh)
                         forControlEvents:UIControlEventValueChanged];
    [_patientListTableView addSubview:_patientListRefreshControl];
}

#pragma mark - Bar Button Actions

- (void)settingsPressed{
     NSLog(@"Settings Pressed");
    
    TRSettingsViewController *settingsVC = [[TRSettingsViewController alloc]init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)addNewPatientPressed{
    NSLog(@"Add New Patient Pressed");
    
    TRAddPatientViewController *addPatientVC = [[TRAddPatientViewController alloc]init];
    [self.navigationController pushViewController:addPatientVC animated:YES];
}

#pragma mark - Refresh Methods

- (void)handlePatientListRefresh{
    [_patientListRefreshControl beginRefreshing];
    NSLog(@"Refresh Begun");
    
    [_patientListRefreshControl endRefreshing];
    NSLog(@"Refresh Completed");
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
    return 3;
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
    if([indexPath row] == 0){
        cell.patientCellPhoto.image = [UIImage imageNamed:@"mark.png"];
        cell.patientCellName.text = @"Mark Bellott";
        cell.patientCellComplaint.text = @"Complaint: Cataracts";
        cell.patientCellBirthdate.text = @"Birthdate: 09/17/1990";
    }
    if([indexPath row] == 1){
        cell.patientCellPhoto.image = [UIImage imageNamed:@"willie.png"];
        cell.patientCellName.text = @"Willie Flaherty";
        cell.patientCellComplaint.text = @"Complaint: Cataracts";
        cell.patientCellBirthdate.text = @"Birthdate: 06/18/1989";
    }
    if([indexPath row] == 2){
        cell.patientCellPhoto.image = [UIImage imageNamed:@"mischa.png"];
        cell.patientCellName.text = @"Mischa Buckler";
        cell.patientCellComplaint.text = @"Complaint: Cataracts";
        cell.patientCellBirthdate.text = @"Birthdate: 04/13/1991";
    }
    
    return cell;
}

#pragma mark - Orientation and Frame Methods

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
