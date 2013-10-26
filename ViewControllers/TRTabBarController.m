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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self setUpNavItems];
}

- (void) setUpNavItems{
    [self.navigationItem.backBarButtonItem setTitle:@"Patient List"];
    [self.navigationItem.backBarButtonItem setTarget:self];
    [self.navigationItem.backBarButtonItem setAction:@selector(backButtonPressed)];
}

- (void)backButtonPressed{
    
}

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
