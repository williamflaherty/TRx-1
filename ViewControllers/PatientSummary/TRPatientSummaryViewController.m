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
    _firstNameLabel.textAlignment = NSTextAlignmentLeft;
    
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
    
    [self.view addSubview:_firstNameLabel];
    [self.view addSubview:_lastNameLabel];
    [self.view addSubview:_birthdateLabel];
    [self.view addSubview:_chiefComplaintLabel];
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
    _firstNameLabel.frame = CGRectMake(437, 458, 300, 21);
    _lastNameLabel.frame = CGRectMake(437, 487, 300, 21);
    _birthdateLabel.frame = CGRectMake(437, 516, 300, 21);
    _chiefComplaintLabel.frame = CGRectMake(437, 545, 300, 21);
}

- (void)resizeFramesForLandscape{
    _photoIDImageView.frame = CGRectMake(160, 208, 352, 352);
    _firstNameLabel.frame = CGRectMake(565, 330, 300, 21);
    _lastNameLabel.frame = CGRectMake(565, 359, 300, 21);
    _birthdateLabel.frame = CGRectMake(565, 388, 300, 21);
    _chiefComplaintLabel.frame = CGRectMake(565, 417, 300, 21);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
