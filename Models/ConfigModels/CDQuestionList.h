//
//  QuestionChain.h
//  TRx
//
//  Created by John Cotham on 1/14/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDChainList, CDOption, CDQuestion;

@interface CDQuestionList : NSManagedObject

@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSNumber * stack_index;
@property (nonatomic, retain) CDChainList *list;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic, retain) NSSet *branches;
@end

@interface CDQuestionList (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(CDQuestion *)value;
- (void)removeQuestionsObject:(CDQuestion *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

- (void)addBranchesObject:(CDOption *)value;
- (void)removeBranchesObject:(CDOption *)value;
- (void)addBranches:(NSSet *)values;
- (void)removeBranches:(NSSet *)values;

@end
