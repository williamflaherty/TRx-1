//
//  TRAddPatientViewController.h
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRBorderedButton;
@class TRBorderedImageView;

@interface TRAddPatientViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//IBOutlets
@property(nonatomic, strong) IBOutlet TRBorderedButton *takePictureButton;
@property(nonatomic, strong) IBOutlet TRBorderedButton *birthdateButton;
@property(nonatomic, strong) IBOutlet TRBorderedButton *chiefComplaintButton;
@property(nonatomic, strong) IBOutlet TRBorderedImageView *photoIDImageView;

//IBActions
- (IBAction)takePicturePressed:(id)sender;

@end
