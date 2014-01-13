//
//  Item.h
//  TRx
//
//  Created by John Cotham on 1/11/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDItemList;

@interface CDItem : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) CDItemList *list;

@end
