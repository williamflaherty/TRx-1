//
//  CDHistory.h
//  TRx
//
//  Created by Mark Bellott on 1/14/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPatient;

@interface CDHistory : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) CDPatient *patient;

@end
