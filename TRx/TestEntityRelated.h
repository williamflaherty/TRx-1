//
//  TestEntityRelated.h
//  TRx
//
//  Created by John Cotham on 9/16/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TestEntity;

@interface TestEntityRelated : NSManagedObject

@property (nonatomic, retain) NSString * textFieldFour;
@property (nonatomic, retain) TestEntity *relatedToMainFields;

@end
