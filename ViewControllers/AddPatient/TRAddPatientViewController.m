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
#import "TRCustomImageView.h"
#import "TRManagedObjectContext.h"
#import "CDItem.h"
#import "CDItemList.h"
#import "CDPatient.h"
#import "CDImage.h"
#import "TRActivePatientManager.h"

#define kPopoverHeightBuffer 100.0f

@interface TRAddPatientViewController ()

@property (nonatomic, strong) TRManagedObjectContext  *managedObjectContext;

@end

@implementation TRAddPatientViewController{
    TRActivePatientManager *_activePatientManager;
    
    TRCustomImageView *_photoIDImageView;
    
    TRCustomButton *_takePictureButton;
    UIBarButtonItem *_submitButton;
    
    UILabel *_firstNameLabel;
    UILabel *_middleNameLabel;
    UILabel *_lastNameLabel;
    UILabel *_birthdateLabel;
    UILabel *_chiefComplaintLabel;
    UILabel *_doctorLabel;
    
    UITextField *_firstNameTextField;
    UITextField *_middleNameTextField;
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
    [self loadObjectContext];
}

- (void)viewWillAppear:(BOOL)animated{
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)initialSetup{
    _activePatientManager = [TRActivePatientManager sharedInstance];
    [self loadLabels];
    [self loadTextFields];
    [self loadButtons];
    [self loadImageView];
    [self loadPickers];
    self.navigationItem.title = @"Add Patient";
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadObjectContext{
    self.managedObjectContext = [TRManagedObjectContext mainThreadContext];
    [self fetchItemsFromCoreData];
}

- (void)fetchItemsFromCoreData{
    
    //
    // NOTE: It is necessary to load the picker data in this way
    //  as a result of Core Data's "lazy fetch" behavior
    //
    
    NSMutableArray *setArray = [[NSMutableArray alloc] init];
    
    NSOrderedSet *doctorSet = [CDItemList getList:@"DoctorList" inContext:[self managedObjectContext]];
    for(CDItem *i in doctorSet){
        [setArray addObject:i.value];
    }
    _doctorPickerData = [[NSArray alloc] initWithArray:setArray];
    
    setArray = [[NSMutableArray alloc] init];
    
    NSOrderedSet *surgerySet = [CDItemList getList:@"SurgeryList" inContext:[self managedObjectContext]];
    for(CDItem *i in surgerySet){
        [setArray addObject:i.value];
    }
    _chiefComplaintPickerData = [[NSArray alloc] initWithArray:setArray];
}

- (void)loadLabels{
    _firstNameLabel = [[UILabel alloc] init];
    _firstNameLabel.font = [UIFont systemFontOfSize:17];
    _firstNameLabel.text = @"First Name";
    
    _middleNameLabel = [[UILabel alloc] init];
    _middleNameLabel.font = [UIFont systemFontOfSize:17];
    _middleNameLabel.text = @"Middle Name";
    
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
    [self.view addSubview:_middleNameLabel];
    [self.view addSubview:_lastNameLabel];
    [self.view addSubview:_birthdateLabel];
    [self.view addSubview:_chiefComplaintLabel];
    [self.view addSubview:_doctorLabel];
}

- (void) loadTextFields{
    _firstNameTextField = [[UITextField alloc] init];
    _firstNameTextField.borderStyle = UITextBorderStyleBezel;
    _firstNameTextField.delegate = self;
    
    _middleNameTextField = [[UITextField alloc] init];
    _middleNameTextField.borderStyle = UITextBorderStyleBezel;
    _middleNameTextField.delegate = self;
    
    _lastNameTextField = [[UITextField alloc] init];
    _lastNameTextField.borderStyle = UITextBorderStyleBezel;
    _lastNameTextField.delegate = self;
    
    _birthdateTextField = [[UITextField alloc] init];
    _birthdateTextField.borderStyle = UITextBorderStyleBezel;
    _birthdateTextField.delegate = self;
    
    _chiefComplaintTextField = [[UITextField alloc] init];
    _chiefComplaintTextField.borderStyle = UITextBorderStyleBezel;
    _chiefComplaintTextField.delegate = self;
    
    _doctorTextField = [[UITextField alloc] init];
    _doctorTextField.borderStyle = UITextBorderStyleBezel;
    _doctorTextField.delegate = self;
    
    [self.view addSubview:_firstNameTextField];
    [self.view addSubview:_middleNameTextField];
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
    [_takePictureButton drawButtonWithDefaultStyle];
    
    _submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitPressed)];
    self.navigationItem.rightBarButtonItem = _submitButton;
    
    [self.view addSubview:_takePictureButton];
    
    _popoverSubmitButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_popoverSubmitButton setTitle:@"OK" forState:UIControlStateNormal];
    [_popoverSubmitButton addTarget:self action:@selector(popoverSubmitPressed) forControlEvents:UIControlEventTouchUpInside];
    [_popoverSubmitButton drawButtonWithDefaultStyle];
}

- (void)loadImageView{
    _photoIDImageView = [[TRCustomImageView alloc] init];
    [_photoIDImageView drawImageViewWithDefaultStyle];
    [self.view addSubview:_photoIDImageView];
}

- (void)loadPickers{
    _birthdatePicker = [[UIDatePicker alloc] init];
    [_birthdatePicker setDatePickerMode:UIDatePickerModeDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [_birthdatePicker setDate:[formatter dateFromString:@"Jan 1, 1990"]];
    
    _chiefComplaintPicker = [[UIPickerView alloc] init];
    _chiefComplaintPicker.delegate = self;
    _chiefComplaintPicker.dataSource = self;
    
    _doctorPicker = [[UIPickerView alloc] init];
    _doctorPicker.delegate = self;
    _doctorPicker.dataSource = self;
}

#pragma mark - Button Methods

- (void)submitPressed{
    BOOL requiredFilled = [self checkAndMarkRequiredFields];
    
    if(!requiredFilled){
        UIAlertView *provideAnswer = [[UIAlertView alloc] initWithTitle:@"Wait!" message:@"Please fill in all required fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [provideAnswer show];
        return;
    }
    
    CDPatient *patient = [NSEntityDescription insertNewObjectForEntityForName:@"CDPatient"
                                                       inManagedObjectContext:self.managedObjectContext];
    patient.firstName = _firstNameTextField.text;
    patient.middleName = _middleNameTextField.text;
    patient.lastName = _lastNameTextField.text;
    patient.surgeryType = _chiefComplaintTextField.text;
    patient.birthday = _birthdatePicker.date;
    patient.doctor = _doctorTextField.text;
    
    CDImage *profileImage = [NSEntityDescription insertNewObjectForEntityForName:@"CDImage"
                                                       inManagedObjectContext:self.managedObjectContext];
    profileImage.data = UIImageJPEGRepresentation(_photoIDImageView.image,0.1);
    profileImage.belongsTo = patient;
    profileImage.belongsToProfile = patient;
    
    [self.managedObjectContext saveContext];
    
    _activePatientManager.activePatient = patient;
    
    TRTabBarController *patientTC =[[TRTabBarController alloc] init];
    [self.navigationController pushViewController:patientTC animated:YES];
}

- (BOOL)checkAndMarkRequiredFields{
    BOOL requiredFilled = YES;
    
    //Required
    
    if([_firstNameTextField.text isEqualToString:@""]){
        requiredFilled = NO;
        _firstNameTextField.layer.backgroundColor =
        [UIColor colorWithRed:0.90 green:0.72 blue:0.69 alpha:1.0].CGColor;
        [_firstNameTextField setNeedsDisplay];
    }
    
    if([_lastNameTextField.text isEqualToString:@""]){
        requiredFilled = NO;
        _lastNameTextField.layer.backgroundColor =
        [UIColor colorWithRed:0.90 green:0.72 blue:0.69 alpha:1.0].CGColor;
        [_lastNameTextField setNeedsDisplay];
    }
    
    if([_birthdateTextField.text isEqualToString:@""]){
        requiredFilled = NO;
        _birthdateTextField.layer.backgroundColor =
        [UIColor colorWithRed:0.90 green:0.72 blue:0.69 alpha:1.0].CGColor;
        [_birthdateTextField setNeedsDisplay];
    }
    
    if(_photoIDImageView.image == nil){
        requiredFilled = NO;
        _photoIDImageView.layer.backgroundColor =
        [UIColor colorWithRed:0.90 green:0.72 blue:0.69 alpha:1.0].CGColor;
        [_photoIDImageView setNeedsDisplay];
    }
    
    //Check the rest
    
    if([_chiefComplaintTextField.text isEqualToString:@""]){
        [_chiefComplaintTextField setText:@"Unknown"];
    }
    
    if([_doctorTextField.text isEqualToString:@""]){
        [_doctorTextField setText:@"Unknown"];
    }
    
    
    return requiredFilled;
}

- (void)popoverSubmitPressed{
    if(_birthdatePopoverController.isPopoverVisible){
        [_birthdatePopoverController dismissPopoverAnimated:YES];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
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
    
    //TODO: Square Camera Overlay
    
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    
//    
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        //Create camera overlay
//        CGRect f = imagePickerController.view.bounds;
//        f.size.height -= imagePickerController.navigationBar.bounds.size.height;
//        CGFloat barHeight = (f.size.height - f.size.width) / 2;
//        UIGraphicsBeginImageContext(f.size);
//        [[UIColor colorWithWhite:0 alpha:.5] set];
//        UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
//        UIRectFillUsingBlendMode(CGRectMake(0, f.size.height - barHeight, f.size.width, barHeight), kCGBlendModeNormal);
//        UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
//        overlayIV.image = overlayImage;
//        [imagePickerController.cameraOverlayView addSubview:overlayIV];
//    }
//    
//    imagePickerController.delegate = self;
//    [self presentViewController:imagePickerController animated:YES completion:nil];
    
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
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    _photoIDImageView.image = image;
}

#pragma mark -  Text FieldMethods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _birthdateTextField){
        [self selectBirthdate];
        [_firstNameTextField resignFirstResponder];
        [_middleNameTextField resignFirstResponder];
        [_lastNameTextField resignFirstResponder];
        return NO;
    }
    else if(textField == _chiefComplaintTextField){
        [self selectChiefComplaint];
        [_firstNameTextField resignFirstResponder];
        [_middleNameTextField resignFirstResponder];
        [_lastNameTextField resignFirstResponder];
        return NO;
    }
    else if(textField == _doctorTextField){
        [self selectDoctor];
        [_firstNameTextField resignFirstResponder];
        [_middleNameTextField resignFirstResponder];
        [_lastNameTextField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_firstNameTextField resignFirstResponder];
    [_middleNameTextField resignFirstResponder];
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
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
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
    _photoIDImageView.frame = CGRectMake(20, 122, 352, 352);
    _middleNameTextField.frame = CGRectMake(398, 189, 350, 30);
    _lastNameTextField.frame = CGRectMake(398, 256, 350, 30);
    _middleNameLabel.frame = CGRectMake(522, 160, 103, 21);
    _firstNameTextField.frame = CGRectMake(398, 122, 350, 30);
    _firstNameLabel.frame = CGRectMake(531, 93, 84, 21);
    _lastNameLabel.frame = CGRectMake(532, 227, 83, 21);
    _birthdateTextField.frame = CGRectMake(398, 323, 350, 30);
    _chiefComplaintTextField.frame = CGRectMake(398, 390, 350, 30);
    _birthdateLabel.frame = CGRectMake(538, 294, 71, 21);
    _doctorTextField.frame = CGRectMake(398, 457, 350, 30);
    _doctorLabel.frame = CGRectMake(547, 428, 53, 21);
    _chiefComplaintLabel.frame = CGRectMake(511, 361, 124, 21);
    _takePictureButton.frame = CGRectMake(148, 482, 97, 30);
}

- (void)resizeFramesForLandscape{
    _photoIDImageView.frame = CGRectMake(149, 104, 352, 352);
    _middleNameTextField.frame = CGRectMake(526, 171, 350, 30);
    _lastNameTextField.frame = CGRectMake(526, 238, 350, 30);
    _middleNameLabel.frame = CGRectMake(650, 142, 103, 21);
    _firstNameTextField.frame = CGRectMake(526, 104, 350, 30);
    _firstNameLabel.frame = CGRectMake(659, 75, 84, 21);
    _lastNameLabel.frame = CGRectMake(660, 209, 83, 21);
    _birthdateTextField.frame = CGRectMake(526, 305, 350, 30);
    _chiefComplaintTextField.frame = CGRectMake(526, 372, 350, 30);
    _birthdateLabel.frame = CGRectMake(666, 276, 71, 21);
    _doctorTextField.frame = CGRectMake(526, 439, 350, 30);
    _doctorLabel.frame = CGRectMake(675, 410, 53, 21);
    _chiefComplaintLabel.frame = CGRectMake(639, 343, 124, 21);
    _takePictureButton.frame = CGRectMake(277, 464, 97, 30);
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
