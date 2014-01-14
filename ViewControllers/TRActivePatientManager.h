//
//  TRActivePatientManager.h
//  TRx
//
//  Created by Mark Bellott on 1/14/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRManagedObjectContext;
@class CDPatient;

@interface TRActivePatientManager : NSObject

@property (nonatomic, retain) TRManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CDPatient *activePatient;

+ (TRActivePatientManager*)sharedInstance;

@end
