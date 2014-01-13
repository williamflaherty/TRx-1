//
//  ItemList.m
//  TRx
//
//  Created by John Cotham on 1/11/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "ItemList.h"


@implementation ItemList

@dynamic name;
@dynamic items;




// returns an NSOrderedSet of names
// fetchName is either "DoctorList" or "SurgeryList" -- as specified in datamodel fetch requests

+(NSOrderedSet *)getList:(NSString *)fetchName inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *fetchRequest = [[[context persistentStoreCoordinator] managedObjectModel] fetchRequestTemplateForName:fetchName];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error retrieving %@ list: %@", fetchName, error);
        return nil;
    }
    ItemList *list = [fetchedObjects objectAtIndex:0];
    
    return list.items;
}

@end
