//
//  CDImage.h
//  TRx
//
//  Created by Mark Bellott on 1/14/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPatient;

@interface CDImage : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSNumber * isProfile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CDPatient *belongsTo;
@property (nonatomic, retain) CDPatient *belongsToProfile;

@end
