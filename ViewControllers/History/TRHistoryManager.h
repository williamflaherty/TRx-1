//
//  TRHistoryManager.h
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    QTypeYesNoDefault,
    QTypeYesNoExplainYes,
    QTypeYesNoExplainNo,
    QTypeYesNoExplainBoth,
    QTypeCheckBoxDefault,
    QTypeCheckBoxOther,
    QTypeTextEntry
}QType;

@class TRManagedObjectContext, TRHistoryViewController;

@interface TRHistoryManager : NSObject

@property (nonatomic, readwrite) BOOL completedAllQuestions;
@property (nonatomic, strong) TRManagedObjectContext  *managedObjectContext;
@property (nonatomic, retain) TRHistoryViewController *historyViewController;

- (void)loadNexQuestion;

- (QType)getNextQuestionType;
- (NSString*)getNextEnglishLabel;
- (NSString*)getNextTranslatedLabel;
- (NSArray*)getNextQuestionOptions;

- (void)saveCurrentAnswers;


@end
