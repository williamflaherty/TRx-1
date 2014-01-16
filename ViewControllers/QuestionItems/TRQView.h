//
//  TRQView.h
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRHistoryManager.h"

@class TRHistoryManager, TRQLabel, TRCustomButton;

@interface TRQView : UIView

@property (nonatomic, retain) TRQView *connectedView;
@property (nonatomic, readwrite) QType questionType;

@property (nonatomic, retain) TRQLabel *questionLabel;
@property (nonatomic, retain) TRCustomButton *yesButton;
@property (nonatomic, retain) TRCustomButton *noButton;
@property (nonatomic, retain) UITextField *textEntryField;

@property (nonatomic, retain) NSMutableArray *response;

- (void)checkHasAnswer;
- (void)setQuestionLabelText:(NSString *)text;
- (void)buildQuestionOfType:(QType)type withManager:(TRHistoryManager*)manager;

- (void)buildYesNoDefault;
- (void)buildYesNoExplainYes;
- (void)buildYesNoExplainNo;
- (void)buildYesNoExplainBoth;

- (void)buildCheckBoxDefault;
- (void)buildCheckBoxOther;

- (void)buildTextEntry;

@end
