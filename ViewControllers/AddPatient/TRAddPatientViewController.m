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
}

@synthesize takePictureButton = _takePictureButton;
@synthesize birthdateButton = _birthdateButton;
@synthesize chiefComplaintButton = _chiefComplaintButton;
@synthesize photoIDImageView = _photoIDImageView;

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self drawButtons];
    [self drawImageView];
    [self setUpButtons];
}

- (void)drawButtons{
    [_takePictureButton drawBorderWithColor:self.view.tintColor];
    [_birthdateButton drawBorderWithColor:self.view.tintColor];
    [_chiefComplaintButton drawBorderWithColor:self.view.tintColor];

}

- (void)drawImageView{
    [_photoIDImageView drawBorderWithColor:self.view.tintColor];
}

- (void)setUpButtons{
    UIBarButtonItem *submit = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitPressed:)];
    self.navigationItem.rightBarButtonItem = submit;
}

#pragma mark - IBActions
- (void)submitPressed:(id)sender{
    TRTabBarController *patientTC =
    [self.storyboard instantiateViewControllerWithIdentifier:@"TRTabBarController"];
    [self.navigationController pushViewController:patientTC animated:YES];
}

#pragma mark - Camera Methods

- (IBAction)takePicturePressed:(id)sender{
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

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
