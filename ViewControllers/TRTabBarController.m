//
//  TRTabBarController.m
//  TRx
//
//  Created by Mark Bellott on 10/21/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRTabBarController.h"
#import "TRNavigationController.h"

@interface TRTabBarController ()

@end

@implementation TRTabBarController

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self setUpNavItems];
    [self setUpNavigationController];
}

- (void) setUpNavItems{
    [self.navigationItem.leftBarButtonItem setTitle:@"Patient List"];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(backButtonPressed)];
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
