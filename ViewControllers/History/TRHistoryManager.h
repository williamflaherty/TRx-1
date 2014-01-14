//
//  TRHistoryManager.h
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRManagedObjectContext;

@interface TRHistoryManager : NSObject

@property (nonatomic, strong) TRManagedObjectContext  *managedObjectContext;

@end
