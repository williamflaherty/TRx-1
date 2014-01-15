//
//  TRPatientSummaryViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRPatientSummaryViewController.h"
#import "TRBorderedImageView.h"
#import "TRActivePatientManager.h"
#import "CDPatient.h"
#import "CDImage.h"

@interface TRPatientSummaryViewController ()

@end

@implementation TRPatientSummaryViewController{
    TRBorderedImageView *_photoIDImageView;
    
    UILabel *_nameLabel;
    UILabel *_birthdateLabel;
    UILabel *_chiefComplaintLabel;
    UILabel *_doctorLabel;
    
    UILabel *_patientName;
    UILabel *_patientBirthdate;
    UILabel *_patientChiefComplaint;
    UILabel *_patientDoctor;
    
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
    [self loadLabels];
    [self loadActivePatientInfo];
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadImageView{
    _photoIDImageView = [[TRBorderedImageView alloc] initWithFrame:CGRectZero];
    [_photoIDImageView drawBorderWithColor:self.view.tintColor];
    [self.view addSubview:_photoIDImageView];
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
    [formatter setDateFormat:@"mm/dd/yyyy"];
    displayString = [formatter stringFromDate:_activePatient.birthday];
    _patientBirthdate.text = displayString;
    
    displayString = _activePatient.surgeryType;
    _patientChiefComplaint.text = displayString;
    
    _photoIDImageView.image = [UIImage imageWithData:_activePatient.profileImage.data];
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
    _photoIDImageView.frame = CGRectMake(20, 88, 108, 108);
    _nameLabel.frame = CGRectMake(136, 88, 51, 21);
    _birthdateLabel.frame = CGRectMake(136, 117, 75, 21);
    _chiefComplaintLabel.frame = CGRectMake(136, 146, 84, 21);
    _doctorLabel.frame = CGRectMake(136, 175, 57, 21);
    _patientChiefComplaint.frame = CGRectMake(228, 146, 300, 21);
    _patientDoctor.frame = CGRectMake(228, 175, 300, 21);
    _patientName.frame = CGRectMake(228, 88, 300, 21);
    _patientBirthdate.frame = CGRectMake(228, 117, 300, 21);
}

- (void)resizeFramesForLandscape{
    _photoIDImageView.frame = CGRectMake(20, 88, 108, 108);
    _nameLabel.frame = CGRectMake(136, 88, 51, 21);
    _birthdateLabel.frame = CGRectMake(136, 117, 75, 21);
    _chiefComplaintLabel.frame = CGRectMake(136, 146, 84, 21);
    _doctorLabel.frame = CGRectMake(136, 175, 57, 21);
    _patientChiefComplaint.frame = CGRectMake(228, 146, 300, 21);
    _patientDoctor.frame = CGRectMake(228, 175, 300, 21);
    _patientName.frame = CGRectMake(228, 88, 300, 21);
    _patientBirthdate.frame = CGRectMake(228, 117, 300, 21);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
