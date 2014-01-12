//
//  Item.h
//  TRx
//
//  Created by John Cotham on 1/11/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemList;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) ItemList *list;

@end
