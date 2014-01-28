//
//  TRHistoryManager.m
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRHistoryManager.h"
#import "TRManagedObjectContext.h"
#import "TRHistoryViewController.h"
#import "TRActivePatientManager.h"
#import "TRQView.h"
#import "TRCustomButton.h"
#import "TRQCheckBox.h"
#import "CDQuestion.h"
#import "CDQuestionList.h"
#import "CDChainList.h"
#import "CDOption.h"
#import "CDHistory.h"
#import "CDPatient.h"


@implementation TRHistoryManager{
    int currentStackIndex;
    int currentListIndext;
    
    CDQuestion *_currentQuestion;
    CDQuestionList *_currentQuestionList;
    
    NSMutableArray *_mainQuestionListStack;
    NSMutableArray *_previousQuestionListStack;
    
    NSMutableArray *_currentQuestionStack;
    NSMutableArray *_currentPreviousQuestionStack;
    
    TRQView *_mainQuestionView;
    TRQView *_translatedQuestionView;
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
    return _currentQuestion.question_text;
}

- (NSString*)getNextTranslatedLabel{
    return _currentQuestion.translation_text;
}

- (NSArray*)getNextQuestionOptions{
    NSMutableArray *options = [[NSMutableArray alloc] init];

    for(CDOption *o in _currentQuestion.options){
        [options addObject:o];
        NSLog(@"%@", o.option_index);
    }
    
    if([options count] != 0){
        
        options = [[options sortedArrayUsingComparator:^(id obj1, id obj2){
            CDOption *o1 = obj1;
            CDOption *o2 = obj2;
            
            if ([o1.option_index integerValue] < [o2.option_index integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if ([o1.option_index integerValue] > [o2.option_index integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else{
                return (NSComparisonResult)NSOrderedSame;
            }
        }] mutableCopy];
    }
    
    for(CDOption *o in options){
        NSLog(@"%@",o.text);
        NSLog(@"%@", o.option_index);
    }
    
    return options;
}

#pragma mark - Answer handling methods

- (void)saveCurrentAnswers{
    
    _mainQuestionView = _historyViewController.mainQuestion;
    _translatedQuestionView = _historyViewController.translatedQuestion;
    
    if(_mainQuestionView.questionType == QTypeTextEntry){
        [self saveTextEntry];
    }
   
    else if (_mainQuestionView.questionType == QTypeYesNoDefault){
        [self saveYesNoDefault];
    }
    else if (_mainQuestionView.questionType == QTypeYesNoExplainYes){
        [self saveYesNoExplainYes];
    }
    else if (_mainQuestionView.questionType == QTypeYesNoExplainNo){
        [self saveYesNoExplainNo];
    }
    else if (_mainQuestionView.questionType == QTypeYesNoExplainBoth){
        [self saveYesNoExplainBoth];
    }
    
    else if (_mainQuestionView.questionType == QTypeCheckBoxDefault){
        [self saveCheckBoxDefault];
    }
    else if (_mainQuestionView.questionType == QTypeCheckBoxOther){
        [self saveCheckBoxOther];
    }
}

- (CDHistory*)findAnswerForQuestionID:(NSNumber*)qID{
    CDHistory *history = nil;
    
    for(CDHistory *h in [TRActivePatientManager sharedInstance].activePatient.history){
        if([h.key integerValue] == [qID integerValue]){
            history = h;
        }
    }
    
    return history;
}

- (void)saveTextEntry{
    CDHistory *answer = [self findAnswerForQuestionID:_currentQuestion.question_id];
    
    if(answer == nil){
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"CDHistory"
                                                       inManagedObjectContext:_managedObjectContext];
        answer.displayGroup = _currentQuestion.display_group;
        answer.displayText = _currentQuestion.display_text;
        answer.key = [NSString stringWithFormat:@"%@", _currentQuestion.question_id];
        answer.questionText = _currentQuestion.question_text;
        answer.patient = [TRActivePatientManager sharedInstance].activePatient;
    }
    
    answer.value = _mainQuestionView.textEntryField.text;
    
    [_managedObjectContext saveContext];
}

- (void)saveYesNoDefault{
    CDHistory *answer = [self findAnswerForQuestionID:_currentQuestion.question_id];
    
    if(answer == nil){
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"CDHistory"
                                               inManagedObjectContext:_managedObjectContext];
        answer.displayGroup = _currentQuestion.display_group;
        answer.displayText = _currentQuestion.display_text;
        answer.key = [NSString stringWithFormat:@"%@", _currentQuestion.question_id];
        answer.questionText = _currentQuestion.question_text;
        answer.patient = [TRActivePatientManager sharedInstance].activePatient;
    }
    
    NSString *answerString;

    if(_mainQuestionView.yesButton.isSelected){
        answerString = @"Yes";
    }
    else if(_mainQuestionView.noButton.isSelected){
        answerString = @"No";
    }
    
    answer.value = answerString;
    
    [_managedObjectContext saveContext];
}

- (void)saveYesNoExplainYes{
    CDHistory *answer = [self findAnswerForQuestionID:_currentQuestion.question_id];
    
    if(answer == nil){
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"CDHistory"
                                               inManagedObjectContext:_managedObjectContext];
        answer.displayGroup = _currentQuestion.display_group;
        answer.displayText = _currentQuestion.display_text;
        answer.key = [NSString stringWithFormat:@"%@", _currentQuestion.question_id];
        answer.questionText = _currentQuestion.question_text;
        answer.patient = [TRActivePatientManager sharedInstance].activePatient;
    }
    
    NSString *answerString;
    
    if(_mainQuestionView.yesButton.isSelected){
        answerString = [@"Yes: " stringByAppendingString:_mainQuestionView.explainTextField.text];
    }
    else if(_mainQuestionView.noButton.isSelected){
        answerString = @"No";
    }
    
    answer.value = answerString;
    
    [_managedObjectContext saveContext];
}

- (void)saveYesNoExplainNo{
    CDHistory *answer = [self findAnswerForQuestionID:_currentQuestion.question_id];
    
    if(answer == nil){
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"CDHistory"
                                               inManagedObjectContext:_managedObjectContext];
        answer.displayGroup = _currentQuestion.display_group;
        answer.displayText = _currentQuestion.display_text;
        answer.key = [NSString stringWithFormat:@"%@", _currentQuestion.question_id];
        answer.questionText = _currentQuestion.question_text;
        answer.value = _mainQuestionView.textEntryField.text;
        answer.patient = [TRActivePatientManager sharedInstance].activePatient;
    }

    NSString *answerString;
    
    if(_mainQuestionView.yesButton.isSelected){
        answerString = @"Yes";
    }
    else if(_mainQuestionView.noButton.isSelected){
        answerString = [@"No" stringByAppendingString:_mainQuestionView.explainTextField.text];
    }
    
    answer.value = answerString;
    
    [_managedObjectContext saveContext];
}

- (void)saveYesNoExplainBoth{
    CDHistory *answer = [self findAnswerForQuestionID:_currentQuestion.question_id];
    
    if(answer == nil){
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"CDHistory"
                                               inManagedObjectContext:_managedObjectContext];
        answer.displayGroup = _currentQuestion.display_group;
        answer.displayText = _currentQuestion.display_text;
        answer.key = [NSString stringWithFormat:@"%@", _currentQuestion.question_id];
        answer.questionText = _currentQuestion.question_text;
        answer.value = _mainQuestionView.textEntryField.text;
        answer.patient = [TRActivePatientManager sharedInstance].activePatient;
    }

    NSString *answerString;
    
    if(_mainQuestionView.yesButton.isSelected){
        answerString = [@"Yes: " stringByAppendingString:_mainQuestionView.explainTextField.text];
    }
    else if(_mainQuestionView.noButton.isSelected){
        answerString = [@"No" stringByAppendingString:_mainQuestionView.explainTextField.text];
    }
    
    answer.value = answerString;
    
    [_managedObjectContext saveContext];
}

- (void)saveCheckBoxDefault{
    CDHistory *answer = [self findAnswerForQuestionID:_currentQuestion.question_id];
    
    if(answer == nil){
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"CDHistory"
                                               inManagedObjectContext:_managedObjectContext];
        answer.displayGroup = _currentQuestion.display_group;
        answer.displayText = _currentQuestion.display_text;
        answer.key = [NSString stringWithFormat:@"%@", _currentQuestion.question_id];
        answer.questionText = _currentQuestion.question_text;
        answer.value = _mainQuestionView.textEntryField.text;
        answer.patient = [TRActivePatientManager sharedInstance].activePatient;
    }
    
    NSString *answerString;
    int count = 0;
    
    for(TRQCheckBox *cb in _mainQuestionView.checkBoxes){
        if(cb.isSelected){
            if(count == 0){
                answerString = cb.optionValue;
            }
            else{
                answerString = [[answerString stringByAppendingString:@", "]
                                stringByAppendingString:cb.optionValue];
            }
            count++;
        }
    }
    
    answer.value = answerString;
    
    [_managedObjectContext saveContext];
}

- (void)saveCheckBoxOther{
    CDHistory *answer = [self findAnswerForQuestionID:_currentQuestion.question_id];
    
    if(answer == nil){
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"CDHistory"
                                               inManagedObjectContext:_managedObjectContext];
        answer.displayGroup = _currentQuestion.display_group;
        answer.displayText = _currentQuestion.display_text;
        answer.key = [NSString stringWithFormat:@"%@", _currentQuestion.question_id];
        answer.questionText = _currentQuestion.question_text;
        answer.value = _mainQuestionView.textEntryField.text;
        answer.patient = [TRActivePatientManager sharedInstance].activePatient;
    }

    NSString *answerString;
    int count = 0;
    
    for(TRQCheckBox *cb in _mainQuestionView.checkBoxes){
        if(cb.isSelected){
            if(count == 0){
                answerString = cb.optionValue;
            }
            else{
                answerString = [[answerString stringByAppendingString:@", "]
                                stringByAppendingString:cb.optionValue];
            }
            count++;
        }
    }
    
    if(![_mainQuestionView.otherTextField.text isEqualToString:@""]){
        if(count == 0){
            answerString = _mainQuestionView.otherTextField.text;
        }
        else{
            answerString = [[answerString stringByAppendingString:@", "]
                            stringByAppendingString:_mainQuestionView.otherTextField.text];
        }
    }
    
    answer.value = answerString;
    
    [_managedObjectContext saveContext];
}




@end
