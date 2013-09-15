//
//  TRAppDelegate.h
//  TRx
//
//  Created by Mark Bellott on 9/15/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
