//
//  ChainList.h
//  TRx
//
//  Created by John Cotham on 1/12/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChainList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *chains;

@end
