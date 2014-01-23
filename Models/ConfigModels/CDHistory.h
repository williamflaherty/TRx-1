//
//  CDHistory.h
//  TRx
//
//  Created by John Cotham on 1/23/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPatient;

@interface CDHistory : NSManagedObject

@property (nonatomic, retain) NSString * displayGroup;
@property (nonatomic, retain) NSString * displayText;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) CDPatient *patient;

@end
