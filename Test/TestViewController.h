//
//  TestViewController.h
//  TRx
//
//  Created by Mark Bellott on 9/12/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
