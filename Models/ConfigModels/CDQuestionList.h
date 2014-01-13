//
//  QuestionChain.h
//  TRx
//
//  Created by John Cotham on 1/12/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChainList, Question;

@interface QuestionList : NSManagedObject

@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSNumber * stack_index;
@property (nonatomic, retain) ChainList *list;
@property (nonatomic, retain) NSOrderedSet *questions;

@end
