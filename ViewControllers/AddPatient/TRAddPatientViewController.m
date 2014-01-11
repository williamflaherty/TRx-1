//
//  TRAddPatientViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRAddPatientViewController.h"
#import "TRTabBarController.h"
#import "TRCustomButton.h"
#import "TRBorderedImageView.h"

#define kPopoverHeightBuffer 100.0f

@interface TRAddPatientViewController ()

@end

@implementation TRAddPatientViewController{
    TRBorderedImageView *_photoIDImageView;
    
    TRCustomButton *_takePictureButton;
    UIBarButtonItem *_submitButton;
    
    UILabel *_firstNameLabel;
    UILabel *_lastNameLabel;
    UILabel *_birthdateLabel;
    UILabel *_chiefComplaintLabel;
    UILabel *_doctorLabel;
    
    UITextField *_firstNameTextField;
    UITextField *_lastNameTextField;
    
    UITextField *_birthdateTextField;
    UITextField *_chiefComplaintTextField;
    UITextField *_doctorTextField;
    
    NSArray *_chiefComplaintPickerData;
    NSArray *_doctorPickerData;
    
    UIDatePicker *_birthdatePicker;
    UIPickerView *_chiefComplaintPicker;
    UIPickerView *_doctorPicker;
    
    UIViewController *_pickerViewController;
    UIPopoverController *_birthdatePopoverController;
    UIPopoverController *_chiefComplaintPopoverController;
    UIPopoverController *_doctorPopoverController;
    TRCustomButton *_popoverSubmitButton;
}

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
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
    [self loadLabels];
    [self loadTextFields];
    [self loadButtons];
    [self loadImageView];
    [self loadPickerData];
    [self loadPickers];

    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadLabels{
    _firstNameLabel = [[UILabel alloc] init];
    _firstNameLabel.font = [UIFont systemFontOfSize:17];
    _firstNameLabel.text = @"First Name";
    
    _lastNameLabel = [[UILabel alloc] init];
    _lastNameLabel.font = [UIFont systemFontOfSize:17];
    _lastNameLabel.text = @"Last Name";
    
    _birthdateLabel = [[UILabel alloc] init];
    _birthdateLabel.font = [UIFont systemFontOfSize:17];
    _birthdateLabel.text = @"Birthdate";
    
    _chiefComplaintLabel = [[UILabel alloc] init];
    _chiefComplaintLabel.font = [UIFont systemFontOfSize:17];
    _chiefComplaintLabel.text = @"Chief Complaint";
    
    _doctorLabel = [[UILabel alloc] init];
    _doctorLabel.font = [UIFont systemFontOfSize:17];
    _doctorLabel.text = @"Doctor";
    
    [self.view addSubview:_firstNameLabel];
    [self.view addSubview:_lastNameLabel];
    [self.view addSubview:_birthdateLabel];
    [self.view addSubview:_chiefComplaintLabel];
    [self.view addSubview:_doctorLabel];
}

- (void) loadTextFields{
    _firstNameTextField = [[UITextField alloc] init];
    _firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _firstNameTextField.delegate = self;
    
    _lastNameTextField = [[UITextField alloc] init];
    _lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _lastNameTextField.delegate = self;
    
    _birthdateTextField = [[UITextField alloc] init];
    _birthdateTextField.borderStyle = UITextBorderStyleRoundedRect;
    _birthdateTextField.delegate = self;
    
    _chiefComplaintTextField = [[UITextField alloc] init];
    _chiefComplaintTextField.borderStyle = UITextBorderStyleRoundedRect;
    _chiefComplaintTextField.delegate = self;
    
    _doctorTextField = [[UITextField alloc] init];
    _doctorTextField.borderStyle = UITextBorderStyleRoundedRect;
    _doctorTextField.delegate = self;
    
    [self.view addSubview:_firstNameTextField];
    [self.view addSubview:_lastNameTextField];
    [self.view addSubview:_birthdateTextField];
    [self.view addSubview:_chiefComplaintTextField];
    [self.view addSubview:_doctorTextField];
}

- (void)loadButtons{
    _takePictureButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_takePictureButton setTitle:@"Take Photo" forState:UIControlStateNormal];
    [_takePictureButton addTarget:self action:@selector(takePicturePressed)
                 forControlEvents:UIControlEventTouchUpInside];
    [_takePictureButton drawBorderWithColor:self.view.tintColor];
    
    _submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitPressed)];
    self.navigationItem.rightBarButtonItem = _submitButton;
    
    [self.view addSubview:_takePictureButton];
    
    _popoverSubmitButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_popoverSubmitButton setTitle:@"OK" forState:UIControlStateNormal];
    [_popoverSubmitButton addTarget:self action:@selector(popoverSubmitPressed) forControlEvents:UIControlEventTouchUpInside];
    [_popoverSubmitButton drawBorderWithColor:self.view.tintColor];
}

- (void)loadImageView{
    _photoIDImageView = [[TRBorderedImageView alloc] init];
    [_photoIDImageView drawBorderWithColor:self.view.tintColor];
    [self.view addSubview:_photoIDImageView];
}

- (void)loadPickerData{
    _chiefComplaintPickerData = @[@"Cataracts", @"Hernia", @"Unknown"];
    _doctorPickerData = @[@"Jim", @"Frank", @"Bob", @"David", @"Unkown"];
}

- (void)loadPickers{
    _birthdatePicker = [[UIDatePicker alloc] init];
    [_birthdatePicker setDatePickerMode:UIDatePickerModeDate];
    
    _chiefComplaintPicker = [[UIPickerView alloc] init];
    _chiefComplaintPicker.delegate = self;
    _chiefComplaintPicker.dataSource = self;
    
    _doctorPicker = [[UIPickerView alloc] init];
    _doctorPicker.delegate = self;
    _doctorPicker.dataSource = self;
}

#pragma mark - Button Methods

- (void)submitPressed{
    TRTabBarController *patientTC =[[TRTabBarController alloc] init];
    [self.navigationController pushViewController:patientTC animated:YES];
}

- (void)popoverSubmitPressed{
    if(_birthdatePopoverController.isPopoverVisible){
        [_birthdatePopoverController dismissPopoverAnimated:YES];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/DD/YYYY"];
        [_birthdateTextField setText:[dateFormatter stringFromDate: _birthdatePicker.date]];
    }
    else if (_chiefComplaintPopoverController.isPopoverVisible){
        [_chiefComplaintPopoverController dismissPopoverAnimated:YES];
        [_chiefComplaintTextField setText:[_chiefComplaintPickerData objectAtIndex:[_chiefComplaintPicker selectedRowInComponent:0]]];
    }
    else if(_doctorPopoverController.isPopoverVisible){
        [_doctorPopoverController dismissPopoverAnimated:YES];
        [_doctorTextField setText:[_doctorPickerData objectAtIndex:[_doctorPicker selectedRowInComponent:0]]];
    }
}

#pragma mark - Camera Methods

- (void)takePicturePressed{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _photoIDImageView.image = image;;
}

#pragma mark -  Text FieldMethods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _birthdateTextField){
        [self selectBirthdate];
        return NO;
    }
    else if(textField == _chiefComplaintTextField){
        [self selectChiefComplaint];
        return NO;
    }
    else if(textField == _doctorTextField){
        [self selectDoctor];
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_birthdateTextField resignFirstResponder];
    [_chiefComplaintTextField resignFirstResponder];
    [_doctorTextField resignFirstResponder];
}

#pragma mark - Popoever Methods

- (void)selectBirthdate{
    NSLog(@"Birthdate!");
    
    _pickerViewController = [[UIViewController alloc] init];
    _pickerViewController.preferredContentSize =
    CGSizeMake(_birthdatePicker.frame.size.width, _birthdatePicker.frame.size.height + kPopoverHeightBuffer);
    [_pickerViewController.view addSubview:_birthdatePicker];
    
    _popoverSubmitButton.frame = CGRectMake(0, 0, 150, 50);
    _popoverSubmitButton.center = CGPointMake(160, 266);
    [_pickerViewController.view addSubview:_popoverSubmitButton];

    _birthdatePopoverController = [[UIPopoverController alloc] initWithContentViewController:_pickerViewController];
    _birthdatePopoverController.delegate = self;
    [_birthdatePopoverController presentPopoverFromRect:_birthdateTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)selectChiefComplaint{
    NSLog(@"Chief Complaint!");
    
    _pickerViewController = [[UIViewController alloc] init];
    _pickerViewController.preferredContentSize =
    CGSizeMake(_chiefComplaintPicker.frame.size.width, _chiefComplaintPicker.frame.size.height + kPopoverHeightBuffer);
    [_pickerViewController.view addSubview:_chiefComplaintPicker];

    NSLog(@"Width: %f", _chiefComplaintPicker.frame.size.width);
    NSLog(@"Height: %f", _chiefComplaintPicker.frame.size.height);
    
    
    _popoverSubmitButton.frame = CGRectMake(0, 0, 150, 50);
    _popoverSubmitButton.center = CGPointMake(160, 266);
    [_pickerViewController.view addSubview:_popoverSubmitButton];
    
    _chiefComplaintPopoverController = [[UIPopoverController alloc] initWithContentViewController:_pickerViewController];
    _chiefComplaintPopoverController.delegate = self;
    [_chiefComplaintPopoverController presentPopoverFromRect:_chiefComplaintTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)selectDoctor{
    NSLog(@"Doctor!");
    
    _pickerViewController = [[UIViewController alloc] init];
    _pickerViewController.preferredContentSize =
    CGSizeMake(_doctorPicker.frame.size.width, _doctorPicker.frame.size.height + kPopoverHeightBuffer);
    [_pickerViewController.view addSubview:_doctorPicker];
    
    _popoverSubmitButton.frame = CGRectMake(0, 0, 150, 50);
    _popoverSubmitButton.center = CGPointMake(160, 266);
    [_pickerViewController.view addSubview:_popoverSubmitButton];
    
    _doctorPopoverController = [[UIPopoverController alloc] initWithContentViewController:_pickerViewController];
    _doctorPopoverController.delegate = self;
    [_doctorPopoverController presentPopoverFromRect:_doctorTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    if(popoverController == _birthdatePopoverController){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/DD/YYYY"];
        [_birthdateTextField setText:[dateFormatter stringFromDate: _birthdatePicker.date]];
    }
    else if(popoverController == _chiefComplaintPopoverController){
        [_chiefComplaintTextField setText:[_chiefComplaintPickerData objectAtIndex:[_chiefComplaintPicker selectedRowInComponent:0]]];
    }
    else if(popoverController == _doctorPopoverController){
        [_doctorTextField setText:[_doctorPickerData objectAtIndex:[_doctorPicker selectedRowInComponent:0]]];
    }
}

#pragma mark - UIPicker Delegate and Datasource Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == _chiefComplaintPicker){
        return [_chiefComplaintPickerData count];
    }
    else if(pickerView == _doctorPicker){
        return [_doctorPickerData count];
    }
    
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == _chiefComplaintPicker){
        return [_chiefComplaintPickerData objectAtIndex:row];
    }
    else if(pickerView == _doctorPicker){
        return [_doctorPickerData objectAtIndex:row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"Pciked!");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
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
    
    [self handlePopoeverOnSwitch];
}

- (void)resizeFramesForPortrait{
    _photoIDImageView.frame = CGRectMake(20, 307, 352, 352);
    _firstNameTextField.frame = CGRectMake(398, 348, 350, 30);
    _lastNameTextField.frame = CGRectMake(398, 415, 350, 30);
    _firstNameLabel.frame = CGRectMake(531, 319, 84, 21);
    _lastNameLabel.frame = CGRectMake(532, 386, 83, 21);
    _birthdateTextField.frame = CGRectMake(398, 482, 350, 30);
    _chiefComplaintTextField.frame = CGRectMake(398, 549, 350, 30);
    _birthdateLabel.frame = CGRectMake(538, 453, 71, 21);
    _chiefComplaintLabel.frame = CGRectMake(511, 520, 124, 21);
    _doctorTextField.frame = CGRectMake(398, 616, 350, 30);
    _doctorLabel.frame = CGRectMake(547, 587, 53, 21);
    _takePictureButton.frame = CGRectMake(148, 667, 97, 30);
}

- (void)resizeFramesForLandscape{
    _photoIDImageView.frame = CGRectMake(148, 189, 352, 352);
    _firstNameTextField.frame = CGRectMake(530, 230, 350, 30);
    _lastNameTextField.frame = CGRectMake(530, 297, 350, 30);
    _firstNameLabel.frame = CGRectMake(663, 201, 84, 21);
    _lastNameLabel.frame = CGRectMake(664, 268, 83, 21);
    _birthdateTextField.frame = CGRectMake(530, 364, 350, 30);
    _chiefComplaintTextField.frame = CGRectMake(530, 431, 350, 30);
    _birthdateLabel.frame = CGRectMake(670, 335, 71, 21);
    _chiefComplaintLabel.frame = CGRectMake(643, 402, 124, 21);
    _takePictureButton.frame = CGRectMake(276, 549, 97, 30);
    _doctorTextField.frame = CGRectMake(530, 498, 350, 30);
    _doctorLabel.frame = CGRectMake(679, 469, 53, 21);
}

- (void)handlePopoeverOnSwitch{
    if(_birthdatePopoverController.isPopoverVisible){
        [_birthdatePopoverController presentPopoverFromRect:_birthdateTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(_chiefComplaintPopoverController.isPopoverVisible){
        [_chiefComplaintPopoverController presentPopoverFromRect:_chiefComplaintTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(_doctorPopoverController.isPopoverVisible){
        [_doctorPopoverController presentPopoverFromRect:_doctorTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
