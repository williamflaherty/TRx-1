//
//  TRPatientSummaryViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRPatientSummaryViewController.h"
#import "TRBorderedImageView.h"

@interface TRPatientSummaryViewController ()

@end

@implementation TRPatientSummaryViewController{
    TRBorderedImageView *_photoIDImageView;
    
    UILabel *_firstNameLabel;
    UILabel *_lastNameLabel;
    UILabel *_birthdateLabel;
    UILabel *_chiefComplaintLabel;
    UILabel *_doctorLabel;
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
    [self loadImageView];
    [self loadLabels];
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadImageView{
    _photoIDImageView = [[TRBorderedImageView alloc] initWithFrame:CGRectZero];
    [_photoIDImageView drawBorderWithColor:self.view.tintColor];
    [self.view addSubview:_photoIDImageView];
}

-(void)loadLabels{
    _firstNameLabel = [[UILabel alloc] init];
    _firstNameLabel.font = [UIFont systemFontOfSize:17];
    _firstNameLabel.text = @"First Name: ";
    
    _lastNameLabel = [[UILabel alloc] init];
    _lastNameLabel.font = [UIFont systemFontOfSize:17];
    _lastNameLabel.text = @"Last Name: ";
    
    _birthdateLabel = [[UILabel alloc] init];
    _birthdateLabel.font = [UIFont systemFontOfSize:17];
    _birthdateLabel.text = @"Birthdate: ";
    
    _chiefComplaintLabel = [[UILabel alloc] init];
    _chiefComplaintLabel.font = [UIFont systemFontOfSize:17];
    _chiefComplaintLabel.text = @"Chief Complaint: ";
    
    _doctorLabel = [[UILabel alloc] init];
    _doctorLabel.font = [UIFont systemFontOfSize:17];
    _doctorLabel.text = @"Doctor: ";
    
    [self.view addSubview:_firstNameLabel];
    [self.view addSubview:_lastNameLabel];
    [self.view addSubview:_birthdateLabel];
    [self.view addSubview:_chiefComplaintLabel];
    [self.view addSubview:_doctorLabel];
}

#pragma mark - Orientation Handling Methods

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

#pragma mark - Frame Sizing Methods

- (void)resizeFramesForPortrait{
    _photoIDImageView.frame = CGRectMake(32, 336, 352, 352);
    _firstNameLabel.frame = CGRectMake(437, 443, 300, 21);
    _lastNameLabel.frame = CGRectMake(437, 472, 300, 21);
    _birthdateLabel.frame = CGRectMake(437, 501, 300, 21);
    _chiefComplaintLabel.frame = CGRectMake(437, 530, 300, 21);
    _doctorLabel.frame = CGRectMake(437, 559, 300, 21);
}

- (void)resizeFramesForLandscape{
    _photoIDImageView.frame = CGRectMake(160, 208, 352, 352);
    _firstNameLabel.frame = CGRectMake(565, 315, 300, 21);
    _lastNameLabel.frame = CGRectMake(565, 344, 300, 21);
    _birthdateLabel.frame = CGRectMake(565, 373, 300, 21);
    _chiefComplaintLabel.frame = CGRectMake(565, 402, 300, 21);
    _doctorLabel.frame = CGRectMake(565, 431, 300, 21);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
