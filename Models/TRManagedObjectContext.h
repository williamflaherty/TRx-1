//
//  TR.h
//  TRx
//
//  Created by John Cotham on 1/11/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TRManagedObjectContext : NSManagedObjectContext
+ (TRManagedObjectContext *)mainThreadContext;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
-(void)saveContext;


@property (nonatomic, readonly, retain) NSManagedObjectModel *objectModel;
@property (nonatomic, readonly, retain) TRManagedObjectContext *mainObjectContext;
@property (nonatomic, readonly, retain) NSPersistentStoreCoordinator *myPersistentStoreCoordinator;

@end