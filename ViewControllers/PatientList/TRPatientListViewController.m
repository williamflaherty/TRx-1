//
//  TRPatientListViewController.m
//  TRx
//
//  Created by Mark Bellott on 9/11/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import "TRPatientListViewController.h"

@interface TRPatientListViewController (){
    CGSize winSize;
}

@end

@implementation TRPatientListViewController

@synthesize patientListTableView;

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
    [self resizeViewsForOrientation:self.interfaceOrientation];
}
     
- (void) initialSetup{
    [self loadConstants];
}

- (void) loadConstants{
    winSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}


#pragma mark - Orientation Handling Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewsForOrientation:toInterfaceOrientation];
}

-(void) resizeViewsForOrientation:(UIInterfaceOrientation)newOrientation{
    if(newOrientation == UIInterfaceOrientationPortrait
       || newOrientation == UIInterfaceOrientationPortraitUpsideDown){
        patientListTableView.frame = CGRectMake(0, 0, 20, 20);
    }
    else if(newOrientation == UIInterfaceOrientationLandscapeLeft
       || newOrientation == UIInterfaceOrientationLandscapeRight){
        patientListTableView.frame = CGRectMake(0, 0, 10, 10);
    }
    else{
        NSLog(@"Unsupported Orientation Switch: %d", newOrientation);
    }
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
