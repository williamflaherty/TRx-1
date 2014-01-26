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
    int currentStackIndex;
    int currentListIndext;
    
    CDQuestion *_currentQuestion;
    CDQuestionList *_currentQuestionList;
    
    NSMutableArray *_mainQuestionListStack;
    NSMutableArray *_previousQuestionListStack;
    
    NSMutableArray *_currentQuestionStack;
    NSMutableArray *_currentPreviousQuestionStack;
}

@synthesize completedAllQuestions = _completedAllQuestions;

#pragma mark - Init and Load Methods

- (id)init{
    self = [super init];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup{
    _completedAllQuestions = NO;
    
    currentStackIndex = 0;
    currentListIndext = 0;
    
    [self loadContext];
    [self loadQuesitonStacks];
    
}

- (void)loadContext{
    self.managedObjectContext = [TRManagedObjectContext mainThreadContext];
}

#pragma mark - Question Stack Handling Methods

- (void)loadQuesitonStacks{
    _mainQuestionListStack = [[NSMutableArray alloc] init];
    
    NSOrderedSet *stack_chains = [CDChainList getChainsForRequestName:@"StackList" fromContext:[self managedObjectContext]];
    for(CDQuestionList *list in stack_chains){
        [_mainQuestionListStack addObject:list];
    }
    
    
    //Sort the question lists by stack index
    NSArray *sortArray = [_mainQuestionListStack sortedArrayUsingComparator:^(id obj1, id obj2){
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
    
    _mainQuestionListStack = [sortArray mutableCopy];
    _previousQuestionListStack = [[NSMutableArray alloc] initWithCapacity:[_mainQuestionListStack count]];
    
    [self loadNextCurrentStack];
}

- (void)loadNexQuestion{
    if([_currentQuestionStack count] == 0){
        [self loadNextCurrentStack];
    }
    _currentQuestion = [_currentQuestionStack lastObject];
    [_currentQuestionStack removeLastObject];
}

- (void)loadNextCurrentStack{
    
    if([_mainQuestionListStack count] > 0){
        _currentQuestionList = [_mainQuestionListStack lastObject];
        
        [_previousQuestionListStack addObject:[_mainQuestionListStack lastObject]];
        [_mainQuestionListStack removeLastObject];
    
        _currentQuestionStack = [self sortQuestionsBelongingToQuesitonList:_currentQuestionList];
    }
    else{
        
    }
    
}

- (void)checkForBranchInOption:(CDOption*)option{
    if(option.branch_id != nil){
        NSLog(@"Branch!");
    }
    else{
        NSLog(@"No Branch!");
    }
    
}

- (NSMutableArray*)sortQuestionsBelongingToQuesitonList:(CDQuestionList*)qList{
    return [[[qList.questions allObjects] sortedArrayUsingComparator:^(id obj1, id obj2){
        CDQuestion *q1 = obj1;
        CDQuestion *q2 = obj2;
        
        if ([q1.list_index integerValue] < [q2.list_index integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else if ([q1.list_index integerValue] > [q2.list_index integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }] mutableCopy];
}

#pragma mark - Question Accessors

- (QType)getNextQuestionType{
    QType questionType;
    if([_currentQuestion.question_type isEqualToString: @"fill"]){
        questionType = QTypeTextEntry;
    }
    if([_currentQuestion.question_type isEqualToString: @"yes no"]){
        questionType = QTypeYesNoDefault;
    }
    if([_currentQuestion.question_type isEqualToString: @"yes explain"]){
        questionType = QTypeYesNoExplainYes;
    }
    if([_currentQuestion.question_type isEqualToString: @"no expain"]){
        questionType = QTypeYesNoExplainNo;
    }
    if([_currentQuestion.question_type isEqualToString: @"yes and no explain"]){
        questionType = QTypeYesNoExplainBoth;
    }
    if([_currentQuestion.question_type isEqualToString: @"check box"]){
        questionType = QTypeCheckBoxDefault;
    }
    if([_currentQuestion.question_type isEqualToString: @"check box other"]){
        questionType = QTypeCheckBoxOther;
    }
    

    return questionType;
}

- (NSString*)getNextEnglishLabel{
//    NSLog(@"%@",_currentQuestion.question_text);
    return _currentQuestion.question_text;
}

- (NSString*)getNextTranslatedLabel{
//    NSLog(@"%@",_currentQuestion.translation_text);
    return _currentQuestion.translation_text;
}

- (NSArray*)getNextQuestionOptions{
    NSMutableArray *options = [[NSMutableArray alloc] init];

    for(CDOption *o in _currentQuestion.options){
        [options addObject:o];
    }
    
    if([options count] != 0){
        NSEnumerator *reverse = [options reverseObjectEnumerator];
        NSMutableArray *reverseOptions = [[NSMutableArray alloc] init];
        for(CDOption *o in reverse){
            [reverseOptions addObject:o];
        }
        options = reverseOptions;
    }
    
    for(CDOption *o in options){
        NSLog(@"%@",o.text);
    }
    
    return options;
}



@end
