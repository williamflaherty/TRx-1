//
//  TRPatientListViewController.h
//  TRx
//
//  Created by Mark Bellott on 9/11/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPatientListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *patientListTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshPatientListButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addPatientButton;

//IBActions
- (IBAction)refreshPatientList:(id)sender;
- (IBAction)addNewPatient:(id)sender;

@end
