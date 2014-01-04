//
//  TRAddPatientViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRAddPatientViewController.h"
#import "TRTabBarController.h"
#import "TRBorderedButton.h"
#import "TRBorderedImageView.h"

@interface TRAddPatientViewController ()

@end

@implementation TRAddPatientViewController{
    TRBorderedImageView *_photoIDImageView;
    
    TRBorderedButton *_takePictureButton;
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
    
    UIActionSheet *_birthdateActionSheet;
    UIActionSheet *_chiefComplaintActionSheet;
    UIActionSheet *_doctorActionSheet;

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
    _takePictureButton = [TRBorderedButton buttonWithType:UIButtonTypeSystem];
    [_takePictureButton setTitle:@"Take Photo" forState:UIControlStateNormal];
    [_takePictureButton addTarget:self action:@selector(takePicturePressed)
                 forControlEvents:UIControlEventTouchUpInside];
    [_takePictureButton drawBorderWithColor:self.view.tintColor];
    
    _submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitPressed)];
    self.navigationItem.rightBarButtonItem = _submitButton;
    
    [self.view addSubview:_takePictureButton];
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

#pragma mark - Button Methods

- (void)submitPressed{
    TRTabBarController *patientTC =[[TRTabBarController alloc] init];
    [self.navigationController pushViewController:patientTC animated:YES];
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

- (void)selectBirthdate{
    NSLog(@"Birthdate!");
    
    _birthdateActionSheet = [[UIActionSheet alloc] init];
    
    _birthdatePicker = [[UIDatePicker alloc] init];
    [_birthdatePicker setDatePickerMode:UIDatePickerModeDate];
    [_birthdateActionSheet addSubview:_birthdatePicker];
    
    [_birthdateActionSheet showInView:self.view];
}

- (void)selectChiefComplaint{
    NSLog(@"Chief Complaint!");
}

- (void)selectDoctor{
    NSLog(@"Doctor!");
}

#pragma mark - UIPicker Delegate Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return @"Test!";
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
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


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
