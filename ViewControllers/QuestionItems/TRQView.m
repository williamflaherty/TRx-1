//
//  TRQView.m
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRQView.h"
#import "TRQLabel.h"
#import "TRCustomButton.h"

#define FONT_SIZE 20

#define Y_PADDING 20.0f
#define YES_PADDING 0.0f
#define NO_PADDING 250.0f

#define MAX_Y 50.0f
#define MID_Y 256.f
#define MIN_Y 500.0f
#define ENG_X 50.0f
#define TRANS_X 550.0f
#define SELECT_OFFSET 50.0f

#define CONST_WIDTH 425.0f
#define SELECT_WIDTH 375.0f

@implementation TRQView{
    float _totalHeight;
    float _responseHeight;
}

@synthesize connectedView = _connectedView;
@synthesize questionType = _questionType;
@synthesize questionLabel = _questionLabel;
@synthesize yesButton = _yesButton;
@synthesize noButton = _noButton;
@synthesize textEntryField = _textEntryField;
@synthesize response = _response;

#pragma mark - Init and Load Methods

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetUp];
    }
    return self;
}

- (void)initialSetUp{
    [self loadQuestionLabel];
    [self loadResponse];
}

- (void)loadQuestionLabel{
    _questionLabel = [[TRQLabel alloc] init];
    [_questionLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [_questionLabel setTextColor:[UIColor blackColor]];
//    [questionUnion addObject:questionLabel];
    [self addSubview:_questionLabel];
}

- (void)loadResponse{
    _response = [[NSMutableArray alloc] init];
}

# pragma mark - Quesiton and Answer Methods

- (void)checkHasAnswer{
    
}

- (void)setQuestionLabelText:(NSString *)text{
    _questionLabel.text = text;
}

- (void)buildQuestionOfType:(QType)type withManager:(TRHistoryManager*)manager{
    if(type == QTypeYesNoDefault){
        _questionType = QTypeYesNoDefault;
        [self buildYesNoDefault];
    }
    else if(type == QTypeYesNoExplainYes){
        _questionType = QTypeYesNoExplainYes;
        [self buildYesNoExplainYes];
    }
    else if(type == QTypeYesNoExplainNo){
        _questionType = QTypeYesNoExplainNo;
        [self buildYesNoExplainNo];
    }
    else if(type == QTypeYesNoExplainBoth){
        _questionType = QTypeYesNoExplainBoth;
        [self buildYesNoExplainBoth];
    }
    else if(type == QTypeCheckBoxDefault){
        _questionType = QTypeCheckBoxDefault;
        [self buildCheckBoxDefault];
    }
    else if(type == QTypeCheckBoxOther){
        _questionType = QTypeCheckBoxOther;
        [self buildCheckBoxOther];
    }
    else if(type == QTypeTextEntry){
        _questionType = QTypeTextEntry;
        [self buildTextEntry];
    }
    else{
        NSLog(@"Error: Invalid Question Type Encountered");
    }
}

#pragma mark - Yes No Methods

- (void)buildYesNoDefault{
    _yesButton = [[TRCustomButton alloc]initWithFrame:CGRectMake(_questionLabel.frame.origin.x + YES_PADDING, _questionLabel.frame.origin.y + Y_PADDING + _questionLabel.frame.size.height, 150, 75)];
    _noButton = [[TRCustomButton alloc]initWithFrame:CGRectMake(_questionLabel.frame.origin.x + NO_PADDING, _questionLabel.frame.origin.y + Y_PADDING + _questionLabel.frame.size.height, 150, 75)];
    [_yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [_noButton setTitle:@"No" forState:UIControlStateNormal];
    [_yesButton addTarget:self action:@selector(yesPressed) forControlEvents:UIControlEventTouchDown];
    [_noButton addTarget:self action:@selector(noPressed) forControlEvents:UIControlEventTouchDown];
    
    [_yesButton drawButtonWithDefaultStyle];
    [_yesButton deselectButton];
    
    [_noButton drawButtonWithDefaultStyle];
    [_noButton deselectButton];
    
    _responseHeight = _yesButton.frame.size.height;
    [_response addObject:_noButton];
    [_response addObject:_yesButton];
    
    [self addSubview:_yesButton];
    [self addSubview:_noButton];
    [self adjustFrame];
}

- (void)buildYesNoExplainYes{
    
}

- (void)buildYesNoExplainNo{
    
}

- (void)buildYesNoExplainBoth{
    
}

- (void)yesPressed{
    [_yesButton selectButton];
    [_noButton deselectButton];
    [_connectedView.yesButton selectButton];
    [_connectedView.noButton deselectButton];
}

- (void)noPressed{
    [_yesButton deselectButton];
    [_noButton selectButton];
    [_connectedView.yesButton deselectButton];
    [_connectedView.noButton selectButton];
}

#pragma mark - Check Box Methods

- (void)buildCheckBoxDefault{
    
}

- (void)buildCheckBoxOther{
    
}

#pragma mark - Text Entry Methods

- (void)buildTextEntry{
    _textEntryField = [[UITextField alloc] init];
    _textEntryField.borderStyle = UITextBorderStyleBezel;
    _textEntryField.keyboardType = UIKeyboardTypeDefault;
    _textEntryField.autocorrectionType = UITextAutocorrectionTypeNo;
    
//    previousTextEntry = _textEntryField.text;
    
    [_textEntryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
    _textEntryField.frame = CGRectMake(_questionLabel.frame.origin.x, _questionLabel.frame.origin.y + _questionLabel.frame.size.height + Y_PADDING, CONST_WIDTH, 30);
    
    _responseHeight = _textEntryField.frame.size.height + Y_PADDING;
    
    [_response addObject:_textEntryField];
//    [questionUnion addObject:textEntryField];
    
    [self addSubview:_textEntryField];
    
    [self adjustFrame];
}

#pragma mark - Frame Resizing Methods

-(void) adjustFrame{
    float tmpHeight = 0;
    
    tmpHeight += _questionLabel.frame.size.height;
    tmpHeight += _responseHeight;
    
    [self setFrame:CGRectMake(_questionLabel.frame.origin.x, _questionLabel.frame.origin.y, CONST_WIDTH, tmpHeight)];
    
    _totalHeight += tmpHeight;
    
}

@end
