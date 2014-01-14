//
//  TRHistoryViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/26/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRHistoryViewController.h"
#import "TRCustomButton.h"
#import "TRHistoryManager.h"

@interface TRHistoryViewController ()

@end

@implementation TRHistoryViewController{
    TRHistoryManager *_questionManager;
    
    TRCustomButton *_previousQuestionButton;
    TRCustomButton *_nextQuestionButton;
}

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [self loadButtons];
    [self loadManager];
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadButtons{
    _previousQuestionButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_previousQuestionButton setTitle:@"Back" forState:UIControlStateNormal];
    [_previousQuestionButton addTarget:self action:@selector(previousQuestionPressed) forControlEvents:UIControlEventTouchUpInside];
    [_previousQuestionButton drawButtonWithColor:self.view.tintColor];
    
    _nextQuestionButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_nextQuestionButton setTitle:@"Next" forState:UIControlStateNormal];
    [_nextQuestionButton addTarget:self action:@selector(nextQuestionPreseed) forControlEvents:UIControlEventTouchUpInside];
    [_nextQuestionButton drawButtonWithColor:self.view.tintColor];
    
    [self.view addSubview:_previousQuestionButton];
    [self.view addSubview:_nextQuestionButton];
}

- (void)loadManager{
    _questionManager = [[TRHistoryManager alloc] init];
}

#pragma mark - Button Methods

- (void)nextQuestionPreseed{
    NSLog(@"NEXT!");
}

- (void)previousQuestionPressed{
    NSLog(@"BACK!");
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
    _nextQuestionButton.frame = CGRectMake(648, 477, 100, 50);
    _previousQuestionButton.frame = CGRectMake(20, 477, 100, 50);
}

- (void)resizeFramesForLandscape{
    _nextQuestionButton.frame = CGRectMake(904, 359, 100, 50);
    _previousQuestionButton.frame = CGRectMake(20, 359, 100, 50);
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
