//
//  TRQView.m
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRQView.h"
#import "TRHistoryManager.h"
#import "TRQLabel.h"
#import "TRCustomButton.h"
#import "TRQCheckBox.h"
#import "CDOption.h"

#define FONT_SIZE 20

#define VIEW_TOP_PAD 10.0f
#define VIEW_BOT_PAD 10.0f
#define VIEW_LEFT_PAD 10.0f
#define VIEW_RIGHT_PAD 10.0f


#define Y_PADDING 20.0f
#define X_PADDING 20.0f
#define YES_PADDING 0.0f
#define NO_PADDING 250.0f
#define YES_NO_WIDTH 150.0f
#define YES_NO_HEIGHT 75.0f
#define EXPLAIN_PADDING 24.0f

#define MAX_Y 50.0f
#define MID_Y 256.f
#define MIN_Y 500.0f
#define ENG_X 30.0f
#define TRANS_X 530.0f
#define SELECT_OFFSET 50.0f

#define CONST_WIDTH 425.0f
#define SELECT_WIDTH 375.0f

@implementation TRQView{
    float _totalHeight;
    float _responseHeight;
}

@synthesize isEnglish = _isEnglish;
@synthesize connectedView = _connectedView;
@synthesize questionType = _questionType;
@synthesize textEntryField = _textEntryField;
@synthesize questionLabel = _questionLabel;
@synthesize yesButton = _yesButton;
@synthesize noButton = _noButton;
@synthesize explainLabel = _explainLabel;
@synthesize explainTextField = _explainTextField;
@synthesize response = _response;
@synthesize selectionTextFields = _selectionTextFields;
@synthesize checkBoxes = _checkBoxes;
@synthesize otherTextField = _otherTextField;

#pragma mark - Init and Load Methods

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        [self initialSetUp];
    }
    return self;
}

- (void)initialSetUp{
    _isEnglish = YES;
    [self loadArrays];
    [self loadQuestionLabel];
}

- (void)loadQuestionLabel{
    _questionLabel = [[TRQLabel alloc] init];
    [_questionLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [_questionLabel setTextColor:[UIColor blackColor]];
    _questionLabel.frame = CGRectMake(VIEW_LEFT_PAD, VIEW_TOP_PAD,
                                      _questionLabel.frame.size.width, _questionLabel.frame.size.height);
    [self addSubview:_questionLabel];
}

- (void)loadArrays{
    _response = [[NSMutableArray alloc] init];
    _selectionTextFields = [[NSMutableArray alloc] init];
}

# pragma mark - Quesiton and Answer Methods

- (BOOL)checkHasAnswer{
    BOOL hasAnswers = NO;
    
    if(_questionType == QTypeTextEntry){
        if(![_textEntryField.text isEqualToString:@""]){
            hasAnswers = YES;
        }
    }
    else if(_questionType == QTypeYesNoDefault){
        if(_yesButton.isSelected || _noButton.isSelected){
            hasAnswers = YES;
        }
    }
    else if(_questionType == QTypeYesNoExplainYes){
        if(_yesButton.isSelected){
            if(![_explainTextField.text isEqualToString:@""]){
                hasAnswers = YES;
            }
        }
        else if(_noButton.isSelected){
            hasAnswers = YES;
        }
    }
    else if(_questionType == QTypeYesNoExplainNo){
        if(_noButton.isSelected){
            if(![_explainTextField.text isEqualToString:@""]){
                hasAnswers = YES;
            }
        }
        else if(_yesButton.isSelected){
            hasAnswers = YES;
        }
    }
    else if(_questionType == QTypeYesNoExplainBoth){
        if(_yesButton.isSelected || _noButton.isSelected){
            if(![_explainTextField.text isEqualToString:@""]){
                hasAnswers = YES;
            }
        }
    }
    else if(_questionType == QTypeCheckBoxDefault){
        NSInteger selectCount = 0;
        for(TRQCheckBox *cb in _checkBoxes){
            if(cb.isSelected){
                selectCount++;
            }
        }
        if(selectCount > 0){
            hasAnswers = YES;
        }
    }
    else if(_questionType == QTypeCheckBoxOther){
        NSInteger selectCount = 0;
        for(TRQCheckBox *cb in _checkBoxes){
            if(cb.isSelected){
                selectCount++;
            }
        }
        if(selectCount > 0){
            hasAnswers = YES;
        }
    }
    
    
    return hasAnswers;
}

- (void)setQuestionLabelText:(NSString *)text{
    _questionLabel.text = text;
}

- (void)buildQuestionOfType:(QType)type withManager:(TRHistoryManager*)manager{
    
    //Build Yes No
    
    if(type == QTypeYesNoDefault){
        _questionType = QTypeYesNoDefault;
        [self buildYesNoDefault];
    }
    else if(type == QTypeYesNoExplainYes){
        _questionType = QTypeYesNoExplainYes;
        [self buildYesNoDefault];
    }
    else if(type == QTypeYesNoExplainNo){
        _questionType = QTypeYesNoExplainNo;
        [self buildYesNoDefault];
    }
    else if(type == QTypeYesNoExplainBoth){
        _questionType = QTypeYesNoExplainBoth;
        [self buildYesNoDefault];
    }
    
    //Build Check Box
    
    else if(type == QTypeCheckBoxDefault){
        _questionType = QTypeCheckBoxDefault;
        [self buildCheckBoxDefaultWithOptions:[manager getNextQuestionOptions]];
    }
    else if(type == QTypeCheckBoxOther){
        _questionType = QTypeCheckBoxOther;
        [self buildCheckBoxOtherWithOptions:[manager getNextQuestionOptions]];
    }
    
    //Build Text Entry
    
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
    _yesButton = [[TRCustomButton alloc]initWithFrame:
                  CGRectMake(_questionLabel.frame.origin.x + YES_PADDING,
                             _questionLabel.frame.origin.y + Y_PADDING + _questionLabel.frame.size.height,
                             YES_NO_WIDTH, YES_NO_HEIGHT)];
    _noButton = [[TRCustomButton alloc]initWithFrame:
                 CGRectMake(_questionLabel.frame.origin.x + NO_PADDING,
                            _questionLabel.frame.origin.y + Y_PADDING + _questionLabel.frame.size.height,
                            YES_NO_WIDTH, YES_NO_HEIGHT)];
    if(_isEnglish){
        [_yesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [_noButton setTitle:@"No" forState:UIControlStateNormal];
    }
    else{
        [_yesButton setTitle:@"Wi" forState:UIControlStateNormal];
        [_noButton setTitle:@"Pa gen" forState:UIControlStateNormal];
    }
    [_yesButton addTarget:self action:@selector(yesPressed) forControlEvents:UIControlEventTouchDown];
    [_noButton addTarget:self action:@selector(noPressed) forControlEvents:UIControlEventTouchDown];
    
    [_yesButton drawButtonWithDefaultStyle];
    [_yesButton deselectButton];
    
    [_noButton drawButtonWithDefaultStyle];
    [_noButton deselectButton];
    
    _explainLabel = [[TRQLabel alloc] init];
    [_explainLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [_explainLabel setTextColor:[UIColor blackColor]];
    
    if(_isEnglish){
        [_explainLabel setText:@"Please Explain:"];
    }
    else{
        [_explainLabel setText:@"Tanpri Eksplike:"];
    }
    
    
    _explainLabel.frame = CGRectMake(_yesButton.frame.origin.x ,
                                     _yesButton.frame.origin.y + Y_PADDING + _yesButton.frame.size.height,
                                     _explainLabel.frame.size.width, _explainLabel.frame.size.height);
    
    _explainTextField = [[UITextField alloc] init];
    _explainTextField.borderStyle = UITextBorderStyleBezel;
    _explainTextField.keyboardType = UIKeyboardTypeDefault;
    _explainTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _explainTextField.backgroundColor = [UIColor whiteColor];
    [_explainTextField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
    
    _explainTextField.frame = CGRectMake(_explainLabel.frame.origin.x,
                               _explainLabel.frame.size.height + _explainLabel.frame.origin.y + Y_PADDING,
                                CONST_WIDTH, 30);
    
    _responseHeight = _yesButton.frame.size.height + (3*Y_PADDING)
    + _explainLabel.frame.size.height + _explainTextField.frame.size.height;
    [_response addObject:_noButton];
    [_response addObject:_yesButton];
    [_response addObject:_explainLabel];
    [_response addObject:_explainTextField];
    
    [self addSubview:_yesButton];
    [self addSubview:_noButton];

    [self adjustFrame];
}



- (void)yesPressed{
    [_yesButton selectButton];
    [_noButton deselectButton];
    [_connectedView.yesButton selectButton];
    [_connectedView.noButton deselectButton];
    
    if(self.questionType == QTypeYesNoExplainYes){
        [self displayYesNoExplain];
    }
    else if(self.questionType == QTypeYesNoExplainNo){
        [self hideYesNoExplain];
    }
    else if(self.questionType == QTypeYesNoExplainBoth){
        [self displayYesNoExplain];
    }
}

- (void)noPressed{
    [_yesButton deselectButton];
    [_noButton selectButton];
    [_connectedView.yesButton deselectButton];
    [_connectedView.noButton selectButton];
    
    if(self.questionType == QTypeYesNoExplainYes){
        [self hideYesNoExplain];
    }
    else if(self.questionType == QTypeYesNoExplainNo){
        [self displayYesNoExplain];
    }
    else if(self.questionType == QTypeYesNoExplainBoth){
        [self displayYesNoExplain];
    }
}

- (void)displayYesNoExplain{
    [self addSubview:_explainLabel];
    [self addSubview:_explainTextField];
    
    [self.connectedView addSubview: self.connectedView.explainLabel];
    [self.connectedView addSubview: self.connectedView.explainTextField];
    
//    [_explainLabel setHidden:NO];
//    [_explainTextField setHidden:NO];
//    [_explainTextField setEnabled:NO];
//    
//    [self.connectedView.explainLabel setHidden:NO];
//    [self.connectedView.explainTextField setHidden:NO];
//    [self.connectedView.explainTextField setEnabled:NO];
}

- (void)hideYesNoExplain{
    
    [_explainLabel removeFromSuperview];
    [_explainTextField removeFromSuperview];
    
    [self.connectedView.explainLabel removeFromSuperview];
    [self.connectedView.explainTextField removeFromSuperview];

    
//    [_explainLabel setHidden:YES];
//    [_explainTextField setHidden:YES];
//    [_explainTextField setEnabled:YES];
//    
//    [self.connectedView.explainLabel setHidden:YES];
//    [self.connectedView.explainTextField setHidden:YES];
//    [self.connectedView.explainTextField setEnabled:YES];
}

#pragma mark - Check Box Methods

- (void)buildCheckBoxDefaultWithOptions:(NSArray*)options{
    [_selectionTextFields removeAllObjects];
    
    NSInteger count = 0;
    NSMutableArray *tmpButtons = [[NSMutableArray alloc] init];
    NSRegularExpression *otherRegex = [[NSRegularExpression alloc] initWithPattern:@"\\b(o)(t)(h)(e)(r)\\b.*"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    _checkBoxes = [[NSMutableArray alloc] init];
    
    for(CDOption *o in options){
        TRQLabel *tmp = [[TRQLabel alloc]init];
        TRQLabel *lastLabel = [[TRQLabel alloc]init];
        TRQCheckBox *box = [TRQCheckBox buttonWithType:UIButtonTypeCustom];
        TRQCheckBox *lastBox = [[TRQCheckBox alloc]init];
        UITextField *textField = [[UITextField alloc] init];
        
        tmp.constrainedWidth = 375;
        [tmp setText:o.text];
        
        NSUInteger countMatches = [otherRegex numberOfMatchesInString:o.text
                                                              options:0 range:NSMakeRange(0, [o.text length])];
        
        if(countMatches == 0){
            if(count == 0){
                tmp.frame = CGRectMake(_questionLabel.frame.origin.x + SELECT_OFFSET, _questionLabel.frame.origin.y + _questionLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
                box.frame = CGRectMake(_questionLabel.frame.origin.x, _questionLabel.frame.origin.y + _questionLabel.frame.size.height + Y_PADDING, 30, 30);
            }
            else{
                lastLabel = [_response lastObject];
                lastBox = [tmpButtons lastObject];
                tmp.frame = CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
                box.frame = CGRectMake(lastBox.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, 30, 30);
            }
            
            [box setArrayIndex:count];
            box.optionValue = o.text;
            
            _responseHeight += (tmp.frame.size.height + Y_PADDING);
            
            [_response addObject: tmp];
            [_checkBoxes addObject:box];
            [tmpButtons addObject:box];
            
            [box addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:tmp];
            [self addSubview:box];
        }
        else{
            lastLabel = [_response lastObject];
            tmp.frame = CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
            textField.frame = CGRectMake(tmp.frame.origin.x +(lastLabel.text.length * 10), lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, 250, 30);
            textField.delegate = self;
            textField.borderStyle = UITextBorderStyleBezel;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            [_textEntryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
            
            _responseHeight += (tmp.frame.size.height + Y_PADDING);
            
            [_response addObject:tmp];
            [_selectionTextFields addObject:textField];
            
            [self addSubview:tmp];
            [self addSubview:textField];
        }
        count++;
    }
    
    [self adjustFrame];
}

- (void)buildCheckBoxOtherWithOptions:(NSArray*)options{
    [_selectionTextFields removeAllObjects];
    
    NSInteger count = 0;
    NSMutableArray *tmpButtons = [[NSMutableArray alloc] init];
    NSRegularExpression *otherRegex = [[NSRegularExpression alloc] initWithPattern:@"\\b(o)(t)(h)(e)(r)\\b.*"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    _checkBoxes = [[NSMutableArray alloc] init];
    
    for(CDOption *o in options){
        TRQLabel *tmp = [[TRQLabel alloc]init];
        TRQLabel *lastLabel = [[TRQLabel alloc]init];
        TRQCheckBox *box = [TRQCheckBox buttonWithType:UIButtonTypeCustom];
        TRQCheckBox *lastBox = [[TRQCheckBox alloc]init];
        _otherTextField = [[UITextField alloc] init];
        
        tmp.constrainedWidth = 375;
        [tmp setText:o.text];
        
        NSUInteger countMatches = [otherRegex numberOfMatchesInString:o.text
                                                              options:0 range:NSMakeRange(0, [o.text length])];
        
        if(countMatches == 0){
            if(count == 0){
                tmp.frame = CGRectMake(_questionLabel.frame.origin.x + SELECT_OFFSET, _questionLabel.frame.origin.y + _questionLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
                box.frame = CGRectMake(_questionLabel.frame.origin.x, _questionLabel.frame.origin.y + _questionLabel.frame.size.height + Y_PADDING, 30, 30);
            }
            else{
                lastLabel = [_response lastObject];
                lastBox = [tmpButtons lastObject];
                tmp.frame = CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
                box.frame = CGRectMake(lastBox.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, 30, 30);
            }
            
            [box setArrayIndex:count];
            box.optionValue = o.text;
            
            _responseHeight += (tmp.frame.size.height + Y_PADDING);
            
            [_response addObject: tmp];
            [_checkBoxes addObject:box];
            [tmpButtons addObject:box];
            
            [box addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:tmp];
            [self addSubview:box];
        }
        else{
            lastLabel = [_response lastObject];
            tmp.frame = CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
            _otherTextField.frame = CGRectMake(tmp.frame.origin.x +(lastLabel.text.length * 10), lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, 250, 30);
            _otherTextField.delegate = self;
            _otherTextField.borderStyle = UITextBorderStyleBezel;
            _otherTextField.keyboardType = UIKeyboardTypeDefault;
            _otherTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            _otherTextField.backgroundColor = [UIColor whiteColor];
            [_textEntryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
            
            _responseHeight += (tmp.frame.size.height + Y_PADDING);
            
            [_response addObject:tmp];
            [_selectionTextFields addObject:_otherTextField];
            
            [self addSubview:tmp];
            [self addSubview:_otherTextField];
        }
        count++;
    }
    
    [self adjustFrame];
}

- (void)checkPressed:(id)sender{
    TRQCheckBox *cb = (TRQCheckBox*)sender;
    [cb checkPressed];
    
    NSInteger index = [_checkBoxes indexOfObject:cb];
    TRQCheckBox *cbConnected = [_connectedView.checkBoxes objectAtIndex:index];
    [cbConnected checkPressed];
    
}

#pragma mark - Text Entry Methods

- (void)buildTextEntry{
    _textEntryField = [[UITextField alloc] init];
    _textEntryField.borderStyle = UITextBorderStyleBezel;
    _textEntryField.keyboardType = UIKeyboardTypeDefault;
    _textEntryField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_textEntryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
    _textEntryField.backgroundColor = [UIColor whiteColor];
    
    _textEntryField.frame = CGRectMake(_questionLabel.frame.origin.x, _questionLabel.frame.origin.y + _questionLabel.frame.size.height + Y_PADDING, CONST_WIDTH, 30);
    
    _responseHeight = _textEntryField.frame.size.height + Y_PADDING;
    
    [_response addObject:_textEntryField];
    
    [self addSubview:_textEntryField];
    
    [self adjustFrame];
}

#pragma mark - Frame Resizing Methods

-(void) adjustFrame{
    float tmpHeight = 0;
    
    tmpHeight += _questionLabel.frame.size.height;
    tmpHeight += _responseHeight;
    tmpHeight += VIEW_BOT_PAD + VIEW_TOP_PAD;
    
    [self setFrame:CGRectMake(_questionLabel.frame.origin.x, _questionLabel.frame.origin.y,
                              CONST_WIDTH + VIEW_LEFT_PAD + VIEW_RIGHT_PAD, tmpHeight)];
    
    _totalHeight += tmpHeight;
    
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

@end
