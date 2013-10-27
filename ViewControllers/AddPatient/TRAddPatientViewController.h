//
//  TRAddPatientViewController.h
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRBorderedButton;

@interface TRAddPatientViewController : UIViewController

@property(nonatomic, strong) IBOutlet TRBorderedButton *takePictureButton;

-(IBAction)takePicturePressed:(id)sender;

@end
