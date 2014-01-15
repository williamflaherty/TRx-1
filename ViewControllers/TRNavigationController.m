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
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.25 green:0.52 blue:0.76 alpha:1.0]];
        [self.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
        [self.navigationBar setTranslucent:NO];
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
