//
//  CDAppData.h
//  TRx
//
//  Created by John Cotham on 1/23/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDAppData : NSManagedObject

@property (nonatomic, retain) NSNumber * appID;
@property (nonatomic, retain) NSNumber * patientCounter;

@end
