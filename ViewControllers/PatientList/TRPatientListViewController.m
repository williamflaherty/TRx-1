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

@implementation TRPatientListViewController{
    UITableView *_patientListTableView;
}

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
}
     
- (void) initialSetup{
    [self loadConstants];
    [self loadTalbeView];
}

- (void) loadConstants{
    winSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void)loadTalbeView{
    _patientListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
    [self.view addSubview:_patientListTableView];
}

#pragma mark - Memory Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
