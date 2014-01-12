//
//  TRAppDelegate.h
//  TRx
//
//  Created by Mark Bellott on 9/15/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManagedObjectContext.h"

@interface TRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) MyManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
