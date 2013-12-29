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
    UIImage *_photoID;
    
    TRBorderedImageView *_photoIDImageView;
    
    TRBorderedButton *_takePictureButton;
    UIBarButtonItem *_submitButton;
    
    UILabel *_firstNameLabel;
    UILabel *_lastNameLabel;
    UILabel *_birthdateLabel;
    UILabel *_chiefComplaintLabel;
    
    UITextField *_firstNameTextField;
    UITextField *_lastNameTextField;
    UITextField *_birthdateTextField;
    UITextField *_chiefComplaintTextField;
    
//    UIPickerView *_complaintPicker;
//    UIDatePicker *_birthdatePicker;

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

- (void)initialSetup{
    [self loadLabels];
    [self loadTextFields];
    [self loadButtons];
    [self loadImageView];
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
    
    [self.view addSubview:_firstNameLabel];
    [self.view addSubview:_lastNameLabel];
    [self.view addSubview:_birthdateLabel];
    [self.view addSubview:_chiefComplaintLabel];
}

- (void) loadTextFields{
    _firstNameTextField = [[UITextField alloc] init];
    _firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    _lastNameTextField = [[UITextField alloc] init];
    _lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    _birthdateTextField = [[UITextField alloc] init];
    _birthdateTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    _chiefComplaintTextField = [[UITextField alloc] init];
    _chiefComplaintTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:_firstNameTextField];
    [self.view addSubview:_lastNameTextField];
    [self.view addSubview:_birthdateTextField];
    [self.view addSubview:_chiefComplaintTextField];
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

- (void)loadPickers{
//    _birthdatePicker = [[UIDatePicker alloc] init];
//    
//    _complaintPicker = [[UIPickerView alloc] init];
//    _complaintPicker.delegate = self;
//    
//    [self.view addSubview:_birthdatePicker];
//    [self.view addSubview:_complaintPicker];
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
    _photoID = image;
    _photoIDImageView.image = _photoID;
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

- (void)resizeFramesForPortrait{
    _photoIDImageView.frame = CGRectMake(20, 307, 352, 352);
    _firstNameTextField.frame = CGRectMake(398, 382, 350, 30);
    _lastNameTextField.frame = CGRectMake(398, 449, 350, 30);
    _firstNameLabel.frame = CGRectMake(531, 353, 84, 21);
    _lastNameLabel.frame = CGRectMake(532, 420, 83, 21);
    _birthdateTextField.frame = CGRectMake(398, 516, 350, 30);
    _chiefComplaintTextField.frame = CGRectMake(398, 583, 350, 30);
    _birthdateLabel.frame = CGRectMake(538, 487, 71, 21);
    _chiefComplaintLabel.frame = CGRectMake(511, 554, 124, 21);
    _takePictureButton.frame = CGRectMake(148, 667, 97, 30);
}

- (void)resizeFramesForLandscape{
    _photoIDImageView.frame = CGRectMake(148, 189, 352, 352);
    _firstNameTextField.frame = CGRectMake(526, 264, 350, 30);
    _lastNameTextField.frame = CGRectMake(526, 331, 350, 30);
    _firstNameLabel.frame = CGRectMake(659, 235, 84, 21);
    _lastNameLabel.frame = CGRectMake(660, 302, 83, 21);
    _birthdateTextField.frame = CGRectMake(526, 398, 350, 30);
    _chiefComplaintTextField.frame = CGRectMake(526, 465, 350, 30);
    _birthdateLabel.frame = CGRectMake(666, 369, 71, 21);
    _chiefComplaintLabel.frame = CGRectMake(639, 436, 124, 21);
    _takePictureButton.frame = CGRectMake(276, 549, 97, 30);
}


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
