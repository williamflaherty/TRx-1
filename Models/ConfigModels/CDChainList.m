//
//  CDChainList.m
//  TRx
//
//  Created by John Cotham on 1/12/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "CDChainList.h"


@implementation CDChainList

@dynamic name;
@dynamic chains;



+(NSOrderedSet *)getChainsForRequestName:(NSString *)name fromContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[[context persistentStoreCoordinator] managedObjectModel] fetchRequestTemplateForName:name];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error retrieving %@ list: %@", name, error);
        return nil;
    }
    CDChainList *list = [fetchedObjects objectAtIndex:0];
    
    return list.chains;
}



@end
