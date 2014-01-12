//
//  Patient.h
//  TRx
//
//  Created by John Cotham on 12/12/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * surgeryType;
@property (nonatomic, retain) NSString * doctor;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * hasTimeout;
@property (nonatomic, retain) NSNumber * isCurrent;

@end
