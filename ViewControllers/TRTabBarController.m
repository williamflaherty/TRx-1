//
//  TRTabBarController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRTabBarController.h"
#import "TRNavigationController.h"
#import "TRPatientSummaryViewController.h"
#import "TRHistoryViewController.h"

@interface TRTabBarController ()

@end

@implementation TRTabBarController{
    TRPatientSummaryViewController *_summaryTabVC;
    TRHistoryViewController *_historyTabVC;
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
    [self loadViewControllers];
    [self setUpNavItems];
}

- (void)viewDidAppear:(BOOL)animated{
    [self setUpNavigationController];
}

- (void)loadViewControllers{
    _summaryTabVC = [[TRPatientSummaryViewController alloc] init];
    _historyTabVC = [[TRHistoryViewController alloc] init];
    
    _summaryTabVC.title = @"Patient Summary";
    _historyTabVC.title = @"Medical History";
    
    _summaryTabVC.tabBarItem.title = @"Summary";
    _historyTabVC.tabBarItem.title = @"History";
    
    [self setViewControllers:@[_summaryTabVC, _historyTabVC]];
}

- (void) setUpNavItems{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Patient List" style:UIBarButtonItemStyleBordered
                                             target:self action:@selector(backButtonPressed)];
    self.navigationItem.hidesBackButton = YES;
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

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
