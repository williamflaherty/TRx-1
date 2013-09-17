//
//  TestEntity.h
//  TRx
//
//  Created by John Cotham on 9/16/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TestEntityRelated;

@interface TestEntity : NSManagedObject

@property (nonatomic, retain) NSString * textFieldOne;
@property (nonatomic, retain) NSString * textFieldThree;
@property (nonatomic, retain) NSString * textFieldTwo;
@property (nonatomic, retain) TestEntityRelated *relatedField;

@end
