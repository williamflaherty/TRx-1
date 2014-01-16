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

@class TRManagedObjectContext;

@interface TRHistoryManager : NSObject

@property (nonatomic, strong) TRManagedObjectContext  *managedObjectContext;

- (QType)getNextQuestionType;
- (NSString*)getNextEnglishLabel;
- (NSString*)getNextTranslatedLabel;


@end
