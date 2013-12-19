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
    TRBorderedButton *_birthdateButton;
    TRBorderedButton *_chiefComplaintButton;
    UIBarButtonItem *_submitButton;
    
    UILabel *_firstNameLabel;
    UILabel *_lastNameLabel;
    
    UITextField *_firstNameTextField;
    UITextField *_lastNameTextField;

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
    [self loadButtons];
    [self loadImageView];
}

- (void)loadButtons{
    _takePictureButton = [TRBorderedButton buttonWithType:UIButtonTypeRoundedRect];
    _takePictureButton.frame = CGRectMake(336, 469, 97, 30);
    [_takePictureButton setTitle:@"Take Photo" forState:UIControlStateNormal];
    [_takePictureButton addTarget:self action:@selector(takePicturePressed)
                 forControlEvents:UIControlEventTouchUpInside];
    [_takePictureButton drawBorderWithColor:self.view.tintColor];
    
    _birthdateButton = [TRBorderedButton buttonWithType:UIButtonTypeCustom];
    _birthdateButton.frame = CGRectMake(020, 699, 350, 30);
    [_birthdateButton setTitle:@"Birthdate:" forState:UIControlStateNormal];
    [_birthdateButton drawBorderWithColor:self.view.tintColor];
    
    _chiefComplaintButton = [TRBorderedButton buttonWithType:UIButtonTypeCustom];
    _chiefComplaintButton.frame = CGRectMake(398, 699, 350, 30);
    [_chiefComplaintButton setTitle:@"Complaint:" forState:UIControlStateNormal];
    [_chiefComplaintButton drawBorderWithColor:self.view.tintColor];
    
    _submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitPressed)];
    self.navigationItem.rightBarButtonItem = _submitButton;
    
    [self.view addSubview:_takePictureButton];
    [self.view addSubview:_birthdateButton];
    [self.view addSubview:_chiefComplaintButton];
}

- (void)loadImageView{
    _photoIDImageView = [[TRBorderedImageView alloc] initWithFrame:CGRectMake(209, 111, 352, 353)];
    [_photoIDImageView drawBorderWithColor:self.view.tintColor];
    [self.view addSubview:_photoIDImageView];
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

#pragma mark - Orientation Handling Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewsForOrientation:toInterfaceOrientation];
}

- (void)resizeViewsForOrientation:(UIInterfaceOrientation)newOrientation{
    if(newOrientation == UIInterfaceOrientationPortrait
       || newOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
    }
    else if(newOrientation == UIInterfaceOrientationLandscapeLeft
            || newOrientation == UIInterfaceOrientationLandscapeRight){
        
    }
    else{
        NSLog(@"Unsupported Orientation Switch: %d", newOrientation);
    }
}


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
