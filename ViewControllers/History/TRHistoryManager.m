//
//  TRHistoryManager.m
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRHistoryManager.h"
#import "TRManagedObjectContext.h"
#import "CDQuestion.h"
#import "CDQuestionList.h"
#import "CDChainList.h"
#import "CDOption.h"

@implementation TRHistoryManager{
    NSMutableArray *_mainQuestionStack;
    NSMutableArray *_previousQuestionStack;
}

#pragma mark - Init and Load Methods

- (id)init{
    self = [super init];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup{
    [self loadContext];
    [self loadQuesitonStacks];
    
}

- (void)loadContext{
    self.managedObjectContext = [TRManagedObjectContext mainThreadContext];
}

/*
 Question List contains Questions
 Questions Contain Options
 Options point to branchin Question Lists
 These Question Lists Contain 1 to Many Questions
 Go Back to main stack once all Branching is null
*/

- (void)loadQuesitonStacks{
    _mainQuestionStack = [[NSMutableArray alloc] init];
    
    NSOrderedSet *stack_chains = [CDChainList getChainsForRequestName:@"StackList" fromContext:[self managedObjectContext]];
    for(CDQuestionList *list in stack_chains){
        for(CDQuestion *q in list.questions){
            NSLog(@"%@",q.question_text);
            for(CDOption *o in q.options){
                NSLog(@"%@",o.text);
                if(o.branchTo != nil){
                    for(CDQuestion *qb in o.branchTo.questions){
                        NSLog(@"%@", qb.question_text);
                    }
                }
            }
        }
//        [_mainQuestionStack addObject:q];
    }
    
    NSArray *sortArray = [_mainQuestionStack sortedArrayUsingComparator:^(id obj1, id obj2){
        CDQuestionList *q1 = obj1;
        CDQuestionList *q2 = obj2;
        
        if ([q1.stack_index integerValue] < [q2.stack_index integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else if ([q1.stack_index integerValue] > [q2.stack_index integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    _mainQuestionStack = [sortArray mutableCopy];
    
    _previousQuestionStack = [[NSMutableArray alloc] initWithCapacity:[_mainQuestionStack count]];
}

- (QType)getNextQuestionType{
    return QTypeCheckBoxDefault;
}

- (NSString*)getNextEnglishLabel{
    return @"ASDASFASDASDADASDDSFSFD";
}

- (NSString*)getNextTranslatedLabel{
    return @"ASDASDASDASDASDADASDASDASD";
}



@end
