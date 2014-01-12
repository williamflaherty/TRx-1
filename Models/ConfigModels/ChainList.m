//
//  ChainList.m
//  TRx
//
//  Created by John Cotham on 1/12/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "ChainList.h"


@implementation ChainList

@dynamic name;
@dynamic chains;

/*
+(NSOrderedSet *)getStackListFromContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[[context persistentStoreCoordinator] managedObjectModel] fetchRequestTemplateForName:@"StackList"];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error retrieving %@ list: %@", @"StackList", error);
        return nil;
    }
    ChainList *list = [fetchedObjects objectAtIndex:0];
    
    return list.chains;
}*/

@end
