//
//  TRPatientSummaryViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRPatientSummaryViewController.h"
#import "TRCustomImageView.h"
#import "TRCustomButton.h"
#import "TRActivePatientManager.h"
#import "CDPatient.h"
#import "CDImage.h"

@interface TRPatientSummaryViewController ()

@end

@implementation TRPatientSummaryViewController{
    TRCustomImageView *_photoIDImageView;
    TRCustomButton*_editButton;
    
    UILabel *_nameLabel;
    UILabel *_birthdateLabel;
    UILabel *_chiefComplaintLabel;
    UILabel *_doctorLabel;
    
    UILabel *_patientName;
    UILabel *_patientBirthdate;
    UILabel *_patientChiefComplaint;
    UILabel *_patientDoctor;
    
    UITableView *_summarayTableView;
    
    TRActivePatientManager *_activePatientManager;
    CDPatient *_activePatient;
}

#pragma mark - Itit and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)initialSetup{
    _activePatientManager = [TRActivePatientManager sharedInstance];
    _activePatient = _activePatientManager.activePatient;
    [self loadImageView];
    [self loadButtons];
    [self loadLabels];
    [self loadActivePatientInfo];
    [self loadTableView];
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadImageView{
    _photoIDImageView = [[TRCustomImageView alloc] initWithFrame:CGRectZero];
    [_photoIDImageView drawImageViewWithDefaultStyle];
    [self.view addSubview:_photoIDImageView];
}

- (void)loadButtons{
    _editButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [_editButton drawButtonWithDefaultStyle];
    
}

-(void)loadLabels{
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.text = @"Name:";
    
    _birthdateLabel = [[UILabel alloc] init];
    _birthdateLabel.font = [UIFont systemFontOfSize:17];
    _birthdateLabel.text = @"Birthdate:";
    
    _chiefComplaintLabel = [[UILabel alloc] init];
    _chiefComplaintLabel.font = [UIFont systemFontOfSize:17];
    _chiefComplaintLabel.text = @"Complaint:";
    
    _doctorLabel = [[UILabel alloc] init];
    _doctorLabel.font = [UIFont systemFontOfSize:17];
    _doctorLabel.text = @"Doctor:";
    
    _patientName = [[UILabel alloc] init];
    _patientName.font = [UIFont systemFontOfSize:17];
    
    _patientBirthdate = [[UILabel alloc] init];
    _patientBirthdate.font = [UIFont systemFontOfSize:17];
    
    _patientChiefComplaint = [[UILabel alloc] init];
    _patientChiefComplaint.font = [UIFont systemFontOfSize:17];
    
    _patientDoctor = [[UILabel alloc] init];
    _patientDoctor.font = [UIFont systemFontOfSize:17];
    
    [self.view addSubview:_nameLabel];
    [self.view addSubview:_birthdateLabel];
    [self.view addSubview:_chiefComplaintLabel];
    [self.view addSubview:_doctorLabel];
    [self.view addSubview:_patientName];
    [self.view addSubview:_patientBirthdate];
    [self.view addSubview:_patientChiefComplaint];
    [self.view addSubview:_patientDoctor];
}

- (void)loadActivePatientInfo{
    NSString *displayString = [NSString stringWithString:_activePatient.firstName];
    displayString = [displayString stringByAppendingString:@" "];
    displayString = [displayString stringByAppendingString:_activePatient.lastName];
    _patientName.text = displayString;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    displayString = [formatter stringFromDate:_activePatient.birthday];
    _patientBirthdate.text = displayString;
    
    displayString = _activePatient.surgeryType;
    _patientChiefComplaint.text = displayString;
    
    displayString = _activePatient.doctor;
    _patientDoctor.text = displayString;
    
    _photoIDImageView.image = [UIImage imageWithData:_activePatient.profileImage.data];
}

- (void)loadTableView{
    _summarayTableView = [[UITableView alloc] init];
    _summarayTableView.delegate = self;
    _summarayTableView.dataSource = self;
    [self.view addSubview:_summarayTableView];
}

#pragma mark - Button Methods

- (void)editButtonPressed{
    
}

#pragma mark - UITableView Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UITableView DataSource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"patientSummaryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    return cell;
}


#pragma mark - Orientation and Frame Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewsForOrientation:toInterfaceOrientation];
}

- (void)resizeViewsForOrientation:(UIInterfaceOrientation)newOrientation{
    
    if(newOrientation == UIInterfaceOrientationPortrait ||
       newOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        [self resizeFramesForPortrait];
        
    }
    else if(newOrientation == UIInterfaceOrientationLandscapeLeft ||
            newOrientation == UIInterfaceOrientationLandscapeRight){
        
        [self resizeFramesForLandscape];
        
    }
}

- (void)resizeFramesForPortrait{
    _photoIDImageView.frame = CGRectMake(240, 20, 108, 108);
    _nameLabel.frame = CGRectMake(356, 20, 51, 21);
    _birthdateLabel.frame = CGRectMake(356, 49, 75, 21);
    _chiefComplaintLabel.frame = CGRectMake(356, 78, 84, 21);
    _doctorLabel.frame = CGRectMake(356, 107, 57, 21);
    _patientChiefComplaint.frame = CGRectMake(448, 78, 300, 21);
    _patientDoctor.frame = CGRectMake(448, 107, 300, 21);
    _patientName.frame = CGRectMake(448, 20, 300, 21);
    _patientBirthdate.frame = CGRectMake(448, 49, 300, 21);
    _summarayTableView.frame = CGRectMake(0.0, 165, 768, 859);
}

- (void)resizeFramesForLandscape{
    _photoIDImageView.frame = CGRectMake(370, 20, 108, 108);
    _nameLabel.frame = CGRectMake(486, 20, 51, 21);
    _birthdateLabel.frame = CGRectMake(486, 49, 75, 21);
    _chiefComplaintLabel.frame = CGRectMake(486, 78, 84, 21);
    _doctorLabel.frame = CGRectMake(486, 107, 57, 21);
    _patientChiefComplaint.frame = CGRectMake(578, 78, 300, 21);
    _patientDoctor.frame = CGRectMake(578, 107, 300, 21);
    _patientName.frame = CGRectMake(578, 20, 300, 21);
    _patientBirthdate.frame = CGRectMake(578, 49, 300, 21);
    _summarayTableView.frame = CGRectMake(0.0, 154, 1024, 614);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
