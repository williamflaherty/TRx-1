//
//  TRAddPatientViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRAddPatientViewController.h"
#import "TRBorderedButton.h"

@interface TRAddPatientViewController ()

@end

@implementation TRAddPatientViewController

@synthesize takePictureButton;

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
}

- (void)drawButtons{
    [takePictureButton drawBorderWithColor:self.view.tintColor];
}

#pragma mark - IBActions

- (IBAction)takePicturePressed:(id)sender{
    
}

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
