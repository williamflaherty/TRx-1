//
//  TRSettingsViewController.m
//  TRx
//
//  Created by Mark Bellott on 1/2/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRSettingsViewController.h"
#import "TRBorderedButton.h"

@interface TRSettingsViewController ()

@end

@implementation TRSettingsViewController{
    TRBorderedButton *_configureButton;
}

#pragma mark Init and Load Methods

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
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadButtons{
    _configureButton = [TRBorderedButton buttonWithType:UIButtonTypeSystem];
    [_configureButton addTarget:self action:@selector(configureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_configureButton setTitle:@"Configure" forState:UIControlStateNormal];
    [_configureButton drawBorderWithColor:self.view.tintColor];
    
    [self.view addSubview:_configureButton];
}

#pragma mark - Button Methods

- (void)configureButtonPressed{
    NSLog(@"Configure Pressed");
}

#pragma mark - Configuration Methods

//
//  -- John --
//  Write your configuration methods here,
//  Call them From configureButtonPressed, above.
//

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

#pragma mark - Frame Sizing Methods

- (void)resizeFramesForPortrait{
    _configureButton.frame = CGRectMake(309, 477, 150, 50);
}

- (void)resizeFramesForLandscape{
    _configureButton.frame = CGRectMake(437, 359, 150, 50);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
