//
//  TRGetFromServer.h
//  TRx
//
//  Created by John Cotham on 1/28/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TRGetFromServer : NSManagedObjectContext

+(void)getPatientList;

@end
