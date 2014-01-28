//
//  TRPatientSummaryViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRPatientSummaryViewController.h"
#import "TREditSummaryViewController.h"
#import "TRCustomButton.h"
#import "TRActivePatientManager.h"
#import "CDPatient.h"
#import "CDImage.h"
#import "CDHistory.h"

@interface TRPatientSummaryViewController ()

@end

@implementation TRPatientSummaryViewController{
    BOOL _isInit;
    
    NSMutableDictionary *_historyDictionary;
    
    NSArray *_historyArray;
    
    UIImageView *_photoIDImageView;
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
    if(!_isInit){
        [self resizeViewsForOrientation:self.interfaceOrientation];
        [self loadActivePatientInfo];
        [_summarayTableView reloadData];
    }
    _isInit = NO;
}

- (void)initialSetup{
    _isInit = YES;
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
    _photoIDImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_photoIDImageView];
}

- (void)loadButtons{
    _editButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [_editButton drawButtonWithDefaultStyle];
    
    [self.view addSubview:_editButton];
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
    [formatter setDateStyle:NSDateFormatterLongStyle];
    displayString = [formatter stringFromDate:_activePatient.birthday];
    _patientBirthdate.text = displayString;
    
    displayString = _activePatient.surgeryType;
    _patientChiefComplaint.text = displayString;
    
    displayString = _activePatient.doctor;
    _patientDoctor.text = displayString;
    
    _photoIDImageView.image = [UIImage imageWithData:_activePatient.profileImage.data];
    
    for(CDHistory *h in _activePatient.history){
        NSLog(@"%@ : %@", h.questionText, h.value);
    }
    
    _historyArray = [_activePatient.history allObjects];
    [self buildHistoryDictionary];
}

- (void)buildHistoryDictionary{
    _historyDictionary = [[NSMutableDictionary alloc] init];
    
    for(CDHistory *h in _historyArray){
        if(h.displayGroup != NULL){
            if([[_historyDictionary allKeys] containsObject:h.displayGroup]){
                [[_historyDictionary objectForKey:h.displayGroup] addObject:h];
            }
            else{
                NSMutableArray *val = [[NSMutableArray alloc] initWithObjects:h, nil];
                [_historyDictionary setObject:val forKey:h.displayGroup];
            }
        }
    }
    
}

- (void)loadTableView{
    _summarayTableView = [[UITableView alloc] init];
    _summarayTableView.delegate = self;
    _summarayTableView.dataSource = self;
    [self.view addSubview:_summarayTableView];
}

#pragma mark - Button Methods

- (void)editButtonPressed{
    TREditSummaryViewController *editVC = [[TREditSummaryViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark - UITableView Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UITableView DataSource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[_historyDictionary allKeys] count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_historyDictionary allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_historyDictionary objectForKey:[[_historyDictionary allKeys] objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"patientSummaryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    CDHistory *h = [[_historyDictionary objectForKey:
                     [[_historyDictionary allKeys] objectAtIndex:[indexPath section]]]
                    objectAtIndex:[indexPath row]];

    cell.textLabel.text = [[h.displayText stringByAppendingString:@"  :  "] stringByAppendingString:h.value];
    
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
    _photoIDImageView.frame = CGRectMake(156, 17, 140, 140);
    _nameLabel.frame = CGRectMake(321, 33, 51, 21);
    _birthdateLabel.frame = CGRectMake(321, 62, 75, 21);
    _chiefComplaintLabel.frame = CGRectMake(321, 91, 84, 21);
    _doctorLabel.frame = CGRectMake(321, 120, 57, 21);
    _patientChiefComplaint.frame = CGRectMake(413, 91, 200, 21);
    _patientDoctor.frame = CGRectMake(413, 120, 200, 21);
    _patientName.frame = CGRectMake(413, 33, 200, 21);
    _patientBirthdate.frame = CGRectMake(413, 62, 200, 21);
    _summarayTableView.frame = CGRectMake(0.0, 165, 768, 859);
    _editButton.frame = CGRectMake(621, 72, 50, 30);

}

- (void)resizeFramesForLandscape{
    _summarayTableView.frame = CGRectMake(0.0, 154, 1024, 614);
    _editButton.frame = CGRectMake(749, 61, 50, 30);
    _photoIDImageView.frame = CGRectMake(284, 6, 140, 140);
    _nameLabel.frame = CGRectMake(449, 22, 51, 21);
    _birthdateLabel.frame = CGRectMake(449, 51, 75, 21);
    _chiefComplaintLabel.frame = CGRectMake(449, 80, 84, 21);
    _doctorLabel.frame = CGRectMake(449, 109, 57, 21);
    _patientChiefComplaint.frame = CGRectMake(541, 80, 200, 21);
    _patientDoctor.frame = CGRectMake(541, 109, 200, 21);
    _patientName.frame = CGRectMake(541, 22, 200, 21);
    _patientBirthdate.frame = CGRectMake(541, 51, 200, 21);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
