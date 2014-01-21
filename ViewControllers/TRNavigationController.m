//
//  TRNavigationController.m
//  TRx
//
//  Created by Mark Bellott on 10/14/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRNavigationController.h"
#import "TRHistoryViewController.h"
#import "TRTabBarController.h"

@interface TRNavigationController ()

@end

@implementation TRNavigationController

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.25 green:0.52 blue:0.76 alpha:1.0]];
        [self.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
        [self.navigationBar setTranslucent:NO];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - Autorotation Methods

- (BOOL)shouldAutorotate{    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    if([self.topViewController isKindOfClass:[TRTabBarController class]]){
        TRTabBarController *tbc = (TRTabBarController*)self.topViewController;
        if([tbc.selectedViewController isKindOfClass:[TRHistoryViewController class]]){
            return UIInterfaceOrientationMaskLandscape;
        }
    }
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
