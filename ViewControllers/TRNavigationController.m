//
//  TRNavigationController.m
//  TRx
//
//  Created by Mark Bellott on 10/14/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRNavigationController.h"

@interface TRNavigationController ()

@end

@implementation TRNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
//        self.navigugationBar.backgroundColor = [UIColor blueColor];
//        self.navigationBar.barTintColor = [UIColor whiteColor];
//        self.navigationBar.barStyle = UIBarStyleDefault;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
