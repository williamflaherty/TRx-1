//
//  TRTabBarController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRTabBarController.h"
#import "TRPatientSummaryViewController.h"
#import "TRHistoryViewController.h"
#import "TRPhysicalViewController.h"
#import "TRSurgeryViewController.h"

@interface TRTabBarController ()

@end

@implementation TRTabBarController{
    TRPatientSummaryViewController *_summaryTabVC;
    TRHistoryViewController *_historyTabVC;
    TRPhysicalViewController *_physicalTabVC;
    TRSurgeryViewController *_surgeryTabVC;
}

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self loadViewControllers];
    [self setUpNavItems];
}

- (void)viewDidAppear:(BOOL)animated{
    [self setUpNavigationController];
}

- (void)loadViewControllers{
    _summaryTabVC = [[TRPatientSummaryViewController alloc] init];
    _historyTabVC = [[TRHistoryViewController alloc] init];
    _physicalTabVC = [[TRPhysicalViewController alloc] init];
    _surgeryTabVC = [[TRSurgeryViewController alloc] init];
    
    _summaryTabVC.title = @"Patient Summary";
    _historyTabVC.title = @"Medical History";
    _physicalTabVC.title = @"Physical Exam";
    _surgeryTabVC.title = @"Surgery";
    
    _summaryTabVC.tabBarItem.title = @"Summary";
    _historyTabVC.tabBarItem.title = @"History";
    _physicalTabVC.tabBarItem.title = @"Physical";
    _surgeryTabVC.tabBarItem.title = @"Surgery";
    
    [self setViewControllers:@[_summaryTabVC, _historyTabVC, _physicalTabVC, _surgeryTabVC]];
}

- (void) setUpNavItems{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Patient List" style:UIBarButtonItemStyleBordered
                                             target:self action:@selector(backButtonPressed)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = self.selectedViewController.title;
}

- (void)setUpNavigationController{
    NSInteger vcCount = self.navigationController.viewControllers.count;
    if(vcCount == 3){
        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        [viewControllers removeObjectAtIndex:1];
        
        self.navigationController.viewControllers = viewControllers;
    }
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Tab Bar Controller Methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    self.navigationItem.title = viewController.title;
}


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
