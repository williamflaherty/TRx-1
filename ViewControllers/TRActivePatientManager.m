//
//  TRActivePatientManager.m
//  TRx
//
//  Created by Mark Bellott on 1/14/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRActivePatientManager.h"
#import "TRManagedObjectContext.h"
#import "CDPatient.h"

@implementation TRActivePatientManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize activePatient = _activePatient;

#pragma mark - Singleton Method

+ (TRActivePatientManager*)sharedInstance{
    static TRActivePatientManager *activePatietManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activePatietManager = [[self alloc] init];
    });

    return activePatietManager;
}

#pragma mark - Init and Load

- (id)init{
    self = [super init];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup{
    self.managedObjectContext = [TRManagedObjectContext mainThreadContext];
    [self loadActivePatient];
}

- (void)loadActivePatient{
    
}

@end
