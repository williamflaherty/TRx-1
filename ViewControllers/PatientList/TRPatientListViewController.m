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
#import "CDPatient.h"
#import "CDImage.h"
#import "TRActivePatientManager.h"

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
    
    NSArray *_patientArray;
    
    TRActivePatientManager *_activePatientManager;
}

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _activePatientManager = [TRActivePatientManager sharedInstance];
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
    [self fetchPatietData];
    
    [_patientListTableView reloadData];
}

- (void)clearTableViewData{
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [_patientListTableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [_patientListTableView numberOfRowsInSection:j]; ++i)
        {
            [cells addObject:[_patientListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
        }
    }
    
    for(TRPatientListCell *cell in cells){
        cell.patientCellBirthdate = nil;
        cell.patientCellComplaint = nil;
        cell.patientCellName = nil;
        cell.patientCellPhoto = nil;
    }
}
     
- (void)initialSetup{
    self.managedObjectContext = [TRManagedObjectContext mainThreadContext];
    [self loadConstants];
    [self loadBarButtonItems];
    [self fetchPatietData];
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

- (void)fetchPatietData{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDPatient"];
    
    NSError *error = nil;
    NSArray *fetchedObjects;
    
    if(fetchRequest){
        fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
    _patientArray = [[NSArray alloc] initWithArray:fetchedObjects];
    
    [self sortPatientArray];
    
    _activePatientManager.activePatient = nil;
}

- (void)sortPatientArray{
    NSArray *sortArray = [_patientArray sortedArrayUsingComparator:^(id obj1, id obj2){
        CDPatient *q1 = obj1;
        CDPatient *q2 = obj2;
        
        NSString *nameString1 = [q1.firstName stringByAppendingString:q1.lastName];
        NSString *nameString2 = [q2.firstName stringByAppendingString:q2.lastName];
        
        return [nameString1 compare:nameString2];
    }];
    
    _patientArray = sortArray;
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
    
    [self fetchPatietData];
    [_patientListTableView reloadData];
    
    [_patientListRefreshControl endRefreshing];
    NSLog(@"Refresh Completed");
}

#pragma mark - UITableViewDelegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _activePatientManager.activePatient = [_patientArray objectAtIndex:[indexPath row]];
    
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
    return [_patientArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"patientListCell";
    TRPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[TRPatientListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CDPatient *patient = [_patientArray objectAtIndex:[indexPath row]];
    CDImage *image = patient.profileImage;
    
    cell.patientCellPhoto.image = [UIImage imageWithData:image.data];
    
    cell.patientCellName.text = [patient.firstName stringByAppendingString:
                                 [@" " stringByAppendingString:patient.lastName]];
    
    cell.patientCellComplaint.text = patient.surgeryType;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.patientCellBirthdate.text = [formatter stringFromDate:patient.birthday];
    
    
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
    _patientListTableView.frame = CGRectMake(0, 0, winSize.width, winSize.height -
                                             (self.navigationController.navigationBar.frame.size.height + 14));
}

- (void)resizeFramesForLandscape{
    _patientListTableView.frame = CGRectMake(0, 0, winSize.height, winSize.width -
                                             (self.navigationController.navigationBar.frame.size.height + 14));
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
