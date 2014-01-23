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
#import "TRQCheckBox.h"

#define FONT_SIZE 20

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
@synthesize textEntryField = _textEntryField;
@synthesize questionLabel = _questionLabel;
@synthesize yesButton = _yesButton;
@synthesize noButton = _noButton;
@synthesize explainLabel = _explainLabel;
@synthesize explainTextField = _explainTextField;
@synthesize response = _response;
@synthesize selectionTextFields = _selectionTextFields;
@synthesize checkBoxes = _checkBoxes;

#pragma mark - Init and Load Methods

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetUp];
    }
    return self;
}

- (void)initialSetUp{
    [self loadArrays];
    [self loadQuestionLabel];
}

- (void)loadQuestionLabel{
    _questionLabel = [[TRQLabel alloc] init];
    [_questionLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [_questionLabel setTextColor:[UIColor blackColor]];
    [self addSubview:_questionLabel];
}

- (void)loadArrays{
    _response = [[NSMutableArray alloc] init];
    _selectionTextFields = [[NSMutableArray alloc] init];
}

# pragma mark - Quesiton and Answer Methods

- (void)checkHasAnswer{
    
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
        [self buildCheckBoxDefaultWithOptions:@[@"One!",@"Two!"]];
    }
    else if(type == QTypeCheckBoxOther){
        _questionType = QTypeCheckBoxOther;
        [self buildCheckBoxOtherWithOptions:@[]];
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
    
    [_yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [_noButton setTitle:@"No" forState:UIControlStateNormal];
    [_yesButton addTarget:self action:@selector(yesPressed) forControlEvents:UIControlEventTouchDown];
    [_noButton addTarget:self action:@selector(noPressed) forControlEvents:UIControlEventTouchDown];
    
    [_yesButton drawButtonWithDefaultStyle];
    [_yesButton deselectButton];
    
    [_noButton drawButtonWithDefaultStyle];
    [_noButton deselectButton];
    
    _explainLabel = [[TRQLabel alloc] init];
    [_explainLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [_explainLabel setTextColor:[UIColor blackColor]];
    [_explainLabel setText:@"Explain:"];
    _explainLabel.frame = CGRectMake(_yesButton.frame.origin.x ,
                                     _yesButton.frame.origin.y + Y_PADDING + _yesButton.frame.size.height,
                                     _explainLabel.frame.size.width, _explainLabel.frame.size.height);
    
    _explainTextField = [[UITextField alloc] init];
    _explainTextField.borderStyle = UITextBorderStyleBezel;
    _explainTextField.keyboardType = UIKeyboardTypeDefault;
    _explainTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_explainTextField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
    
    _explainTextField.frame = CGRectMake(_explainLabel.frame.origin.x + X_PADDING + _explainLabel.frame.size.width,
                               _explainLabel.frame.origin.y,
                                CONST_WIDTH - _explainLabel.frame.size.width - X_PADDING - EXPLAIN_PADDING,
                               30);
    
    [_explainLabel setHidden:YES];
    [_explainTextField setHidden:YES];
    
    _responseHeight = _yesButton.frame.size.height + Y_PADDING + _explainLabel.frame.size.height;
    [_response addObject:_noButton];
    [_response addObject:_yesButton];
    [_response addObject:_explainLabel];
    [_response addObject:_explainTextField];
    
    [self addSubview:_yesButton];
    [self addSubview:_noButton];
    [self addSubview:_explainLabel];
    [self addSubview:_explainTextField];
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
    [_explainLabel setHidden:NO];
    [_explainTextField setHidden:NO];
    [_explainTextField setEnabled:NO];
}

- (void)hideYesNoExplain{
    [_explainLabel setHidden:YES];
    [_explainTextField setHidden:YES];
    [_explainTextField setEnabled:YES];
}

#pragma mark - Check Box Methods

- (void)buildCheckBoxDefaultWithOptions:(NSArray*)options{
    [_selectionTextFields removeAllObjects];
    
    NSInteger count = 0;
    NSMutableArray *tmpButtons = [[NSMutableArray alloc] init];
    NSRegularExpression *otherRegex = [[NSRegularExpression alloc] initWithPattern:@"\\b(o)(t)(h)(e)(r)\\b.*"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    for(NSString *s in options){
        TRQLabel *tmp = [[TRQLabel alloc]init];
        TRQLabel *lastLabel = [[TRQLabel alloc]init];
        TRQCheckBox *box = [TRQCheckBox buttonWithType:UIButtonTypeCustom];
        TRQCheckBox *lastBox = [[TRQCheckBox alloc]init];
        UITextField *textField = [[UITextField alloc] init];
        
        tmp.constrainedWidth = 375;
        [tmp setText:s];
        
        NSUInteger countMatches = [otherRegex numberOfMatchesInString:s
                                                              options:0 range:NSMakeRange(0, [s length])];
        
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
            box.optionLabel = s;
            
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
    
}

- (void)checkPressed:(id)sender{
    TRQCheckBox *cb = (TRQCheckBox*)sender;
    [cb checkPressed];
}

#pragma mark - Text Entry Methods

- (void)buildTextEntry{
    _textEntryField = [[UITextField alloc] init];
    _textEntryField.borderStyle = UITextBorderStyleBezel;
    _textEntryField.keyboardType = UIKeyboardTypeDefault;
    _textEntryField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_textEntryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
    
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
    
    [self setFrame:CGRectMake(_questionLabel.frame.origin.x, _questionLabel.frame.origin.y, CONST_WIDTH, tmpHeight)];
    
    _totalHeight += tmpHeight;
    
}

@end
