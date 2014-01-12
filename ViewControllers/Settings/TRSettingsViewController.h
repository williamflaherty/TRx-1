//
//  TRSettingsViewController.h
//  TRx
//
//  Created by Mark Bellott on 1/2/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManagedObjectContext.h"
#import "Item.h"
#import "ItemList.h"
#import "ChainList.h"
#import "Question.h"
#import "QuestionList.h"
#import "Option.h"

@interface TRSettingsViewController : UIViewController
@property (nonatomic, strong) MyManagedObjectContext  *managedObjectContext;
@end
