//
//  TRSettingsViewController.h
//  TRx
//
//  Created by Mark Bellott on 1/2/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManagedObjectContext.h"

@interface TRSettingsViewController : UIViewController
@property (nonatomic, strong) MyManagedObjectContext  *managedObjectContext;
@end
