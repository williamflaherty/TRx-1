//
//  TRPatientListViewController.m
//  TRx
//
//  Created by Mark Bellott on 9/11/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import "TRPatientListViewController.h"
#import "TRPatientListCell.h"

@interface TRPatientListViewController (){
    CGSize winSize;
}

@end

@implementation TRPatientListViewController

@synthesize patientListTableView = _patientListTableView,
refreshPatientListButton = _refreshPatientListButton,
addPatientButton = _addPatientButton;

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
    [self loadTableView];
    [self laodBarButtons];
}

- (void)loadConstants{
    winSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void) loadTableView{
}

- (void)laodBarButtons{
}

#pragma mark - Bar Button Actions

- (IBAction)refreshPatientList:(id)sender{
    NSLog(@"Refresh Patient List Pressed");
}

- (IBAction)addNewPatient:(id)sender{
    NSLog(@"Add New Patient Pressed");
}

#pragma mark - UITableViewDelegate Methods

#pragma mark - UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"patientListCell";
    TRPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *patientPhotoID = (UIImageView*)[cell viewWithTag:100];
    patientPhotoID.image = [UIImage imageNamed:@"Thumb.jpg"];
    
    UILabel *patientNameLabel = (UILabel*)[cell viewWithTag:101];
    patientNameLabel.text = @"Mark Bellott";
    
    UILabel *patientComplaintLabel = (UILabel*)[cell viewWithTag:102];
    patientComplaintLabel.text = @"Stress";
    
    return cell;
}

#pragma mark - Orientation Handling Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewsForOrientation:toInterfaceOrientation];
}

- (void)resizeViewsForOrientation:(UIInterfaceOrientation)newOrientation{
    if(newOrientation == UIInterfaceOrientationPortrait
       || newOrientation == UIInterfaceOrientationPortraitUpsideDown){
        _patientListTableView.frame = CGRectMake(0, 0, 20, 20);
    }
    else if(newOrientation == UIInterfaceOrientationLandscapeLeft
       || newOrientation == UIInterfaceOrientationLandscapeRight){
        _patientListTableView.frame = CGRectMake(0, 0, 10, 10);
    }
    else{
        NSLog(@"Unsupported Orientation Switch: %d", newOrientation);
    }
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
