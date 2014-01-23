//
//  TRHistoryViewController.m
//  TRx
//
//  Created by Mark Bellott on 10/26/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRHistoryViewController.h"
#import "TRCustomButton.h"
#import "TRHistoryManager.h"
#import "TRQView.h"

#define MAX_Y 50.0f
#define MID_Y 250.0f
#define MIN_Y 500.0f
#define ENG_X 50.0f
#define TRANS_X 550.0f

@interface TRHistoryViewController (){
    CGSize winSize;
}

@end

@implementation TRHistoryViewController{
    TRHistoryManager *_questionManager;
    
    NSInteger _pageCount;
    BOOL _lastQuestionreached;
    BOOL _hasNextPages;
    
    TRCustomButton *_previousQuestionButton;
    TRCustomButton *_nextQuestionButton;
    
    UIView *_seperator;
    
    TRQView *_mainQuestion;
    TRQView *_translatedQuestion;
    
    NSMutableArray *_previousPages;
    NSMutableArray *_nextPages;
    NSMutableArray *_answers;
}

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
    //OMG IT WORKS!
    //Kind Of...
//    if(self.interfaceOrientation != UIInterfaceOrientationLandscapeLeft &&
//        self.interfaceOrientation != UIInterfaceOrientationLandscapeRight){
//        [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:")
//                                       withObject:(__bridge id)((void*)UIInterfaceOrientationLandscapeRight)];
//    }
    
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)initialSetup{
    winSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self loadVariables];
    [self loadButtons];
    [self loadSeperator];
    [self loadManager];
    [self loadQuestionViews];
    
    [self resizeViewsForOrientation:self.interfaceOrientation];
}

- (void)loadVariables{
    _pageCount = 1;
    _lastQuestionreached = NO;
    _hasNextPages = NO;
    _answers = [[NSMutableArray alloc] init];
}

- (void)loadButtons{
    _previousQuestionButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_previousQuestionButton setTitle:@"Back" forState:UIControlStateNormal];
    [_previousQuestionButton addTarget:self action:@selector(previousQuestionPressed) forControlEvents:UIControlEventTouchUpInside];
    [_previousQuestionButton drawButtonWithDefaultStyle];
    [_previousQuestionButton setHidden:YES];
    
    _nextQuestionButton = [TRCustomButton buttonWithType:UIButtonTypeSystem];
    [_nextQuestionButton setTitle:@"Next" forState:UIControlStateNormal];
    [_nextQuestionButton addTarget:self action:@selector(nextQuestionPreseed) forControlEvents:UIControlEventTouchUpInside];
    [_nextQuestionButton drawButtonWithDefaultStyle];
    
    [self.view addSubview:_previousQuestionButton];
    [self.view addSubview:_nextQuestionButton];
}

- (void)loadSeperator{
    _seperator = [[UIView alloc] init];
    _seperator.backgroundColor = [UIColor colorWithRed:0.25 green:0.52 blue:0.76 alpha:1.0];
    [self.view addSubview:_seperator];
}

- (void)loadManager{
    _questionManager = [[TRHistoryManager alloc] init];
}

- (void)loadQuestionViews{
    _mainQuestion = [[TRQView alloc] init];
    _translatedQuestion = [[TRQView alloc] init];
}

- (void)loadPageArrays{
    _previousPages = [[NSMutableArray alloc] init];
    _nextPages = [[NSMutableArray alloc] init];
}

#pragma mark - Button Methods

- (void)nextQuestionPreseed{
    NSLog(@"NEXT!");
    [self loadNextQuestion];
}

- (void)previousQuestionPressed{
    NSLog(@"BACK!");
    [self loadPreviousQuestion];
}

#pragma mark - Touch Handling Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"TOUCH!");
    if(_mainQuestion.questionType == QTypeTextEntry){
        [_mainQuestion.textEntryField resignFirstResponder];
        [_translatedQuestion.textEntryField resignFirstResponder];
    }
    else if(_mainQuestion.questionType == QTypeYesNoExplainYes ||
            _mainQuestion.questionType == QTypeYesNoExplainNo ||
            _mainQuestion.questionType == QTypeYesNoExplainBoth){
        [_mainQuestion.explainTextField resignFirstResponder];
        [_translatedQuestion.explainTextField resignFirstResponder];
    }
}

#pragma mark - Question Handling Methods

- (void)loadNextQuestion{
    [_questionManager loadNexQuestion];
    
    _pageCount++;
    
    if(_hasNextPages){
        
    }
    
    TRQView *newMainQuestion = [[TRQView alloc] init];
    TRQView *newTransQuestion = [[TRQView alloc] init];
    
    if(_pageCount != 1){
        [self dismissCurrentQuestion];
    }
    
    if(_pageCount == 2){
        newMainQuestion.questionType = QTypeTextEntry;
        newTransQuestion.questionType = QTypeTextEntry;
    }
    else if(_pageCount == 3){
        newMainQuestion.questionType = QTypeYesNoDefault;
        newTransQuestion.questionType = QTypeYesNoDefault;
    }
    else if(_pageCount == 4){
        newMainQuestion.questionType = QTypeCheckBoxDefault;
        newTransQuestion.questionType = QTypeCheckBoxDefault;
    }
    
    newMainQuestion.questionType = [_questionManager getNextQuestionType];
    [newMainQuestion setQuestionLabelText:[_questionManager getNextEnglishLabel]];
    
    newTransQuestion.questionType = [_questionManager getNextQuestionType];
    [newTransQuestion setQuestionLabelText:[_questionManager getNextTranslatedLabel]];
    
    //[qHelper updateCurrentIndex];
    
    [newMainQuestion buildQuestionOfType:newMainQuestion.questionType withManager:_questionManager];
    [self setPositionForMainQuestion:newMainQuestion];
    
    [newTransQuestion buildQuestionOfType:newTransQuestion.questionType withManager:_questionManager];
    [self setPositionForTransQuestion:newTransQuestion];
    
    if(newMainQuestion.questionType == QTypeTextEntry){
        newMainQuestion.textEntryField.delegate = self;
        newTransQuestion.textEntryField.delegate = self;
    }
    else if(newMainQuestion.questionType == QTypeYesNoExplainYes ||
            newMainQuestion.questionType == QTypeYesNoExplainNo ||
            newMainQuestion.questionType == QTypeYesNoExplainBoth){
        newMainQuestion.explainTextField.delegate = self;
        newTransQuestion.explainTextField.delegate = self;
    }
    
    newMainQuestion.connectedView = newTransQuestion;
    newTransQuestion.connectedView = newMainQuestion;
    
    _mainQuestion = newMainQuestion;
    _translatedQuestion = newTransQuestion;
    
    [self.view addSubview:_mainQuestion];
    [self.view addSubview:_translatedQuestion];
    
//    [_answers removeAllObjects];
    
    [self checkShouldHideButtons];
    
}

- (void)dismissCurrentQuestion{
    [_mainQuestion removeFromSuperview];
    [_translatedQuestion removeFromSuperview];
}

- (void)loadPreviousQuestion{
    _pageCount--;
    [self checkShouldHideButtons];
}

- (void)checkShouldHideButtons{
    if(_pageCount <= 1){
        [_previousQuestionButton setHidden:YES];
    }
    else if(_lastQuestionreached){
        [_nextQuestionButton setHidden:YES];
    }
    else{
        [_previousQuestionButton setHidden:NO];
        [_nextQuestionButton setHidden:NO];
    }
}

-(void) setPositionForMainQuestion:(TRQView *)q{
    float yPos = MID_Y - (q.frame.size.height/2);
    q.frame = CGRectMake(ENG_X, yPos, q.frame.size.width, q.frame.size.height);
}

-(void) setPositionForTransQuestion:(TRQView *)q{
    float yPos = MID_Y - (q.frame.size.height/2);
    q.frame = CGRectMake(TRANS_X, yPos, q.frame.size.width, q.frame.size.height);
}

#pragma mark - UITextField Delegate Methods

-(void) textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _mainQuestion.textEntryField){
        _translatedQuestion.textEntryField.text = _mainQuestion.textEntryField.text;
    }
    if(textField == _translatedQuestion.textEntryField){
        _mainQuestion.textEntryField.text = _translatedQuestion.textEntryField.text;
    }
}

#pragma mark - Orientation and Frame Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewsForOrientation:toInterfaceOrientation];
}

- (void)resizeViewsForOrientation:(UIInterfaceOrientation)newOrientation{
    
    if(newOrientation == UIInterfaceOrientationPortrait ||
       newOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        [self resizeFramesForPortrait];
    }
    else if(newOrientation == UIInterfaceOrientationLandscapeLeft ||
            newOrientation == UIInterfaceOrientationLandscapeRight){
        
        [self resizeFramesForLandscape];
    }
}

- (void)resizeFramesForPortrait{
//    self.view.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    _nextQuestionButton.frame = CGRectMake(648, 826, 100, 50);
    _previousQuestionButton.frame = CGRectMake(20, 826, 100, 50);
    _seperator.frame = CGRectMake(381, 0.0, 7, 1004);
}

- (void)resizeFramesForLandscape{
//    self.view.frame = CGRectMake(0, 0, winSize.height, winSize.width);
    _nextQuestionButton.frame = CGRectMake(904, 590, 100, 50);
    _previousQuestionButton.frame = CGRectMake(20, 590, 100, 50);
    _seperator.frame = CGRectMake(509, 0.0, 7, 768);
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
