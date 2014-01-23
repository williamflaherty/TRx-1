//
//  CDPatient.h
//  TRx
//
//  Created by John Cotham on 1/23/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDHistory, CDImage;

@interface CDPatient : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * doctor;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * hasTimeout;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * surgeryType;
@property (nonatomic, retain) NSNumber * patientID;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSSet *history;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) CDImage *profileImage;
@end

@interface CDPatient (CoreDataGeneratedAccessors)

- (void)addHistoryObject:(CDHistory *)value;
- (void)removeHistoryObject:(CDHistory *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

- (void)addImagesObject:(CDImage *)value;
- (void)removeImagesObject:(CDImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
