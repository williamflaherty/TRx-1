//
//  TestViewController.m
//  TRx
//
//  Created by Mark Bellott on 9/12/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

@synthesize textFieldOne = _textFieldOne,
textFieldTwo = _textFieldTwo,
textFieldThree = _textFieldThree,
textFieldFour = _textFieldFour,
textOne = _textOne,
textTwo = _textTwo,
textThree = _textThree,
textFour = _textFour;

#pragma mark - Init and Loan Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        _textOne = @"";
        _textTwo = @"";
        _textThree = @"";
        _textFour = @"";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadTextFields];
}

- (void) loadTextFields{
    _textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(125, 257, 200, 30)];
    _textFieldOne.delegate = self;
    [self.view addSubview:_textFieldOne];
    _textFieldOne.delegate = self;
 
    
}

#pragma mark - UITextFiedDelegate Methods

-(void) textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _textFieldOne){
        _textOne = _textFieldOne.text;
    }
    else if(textField == _textFieldTwo){
        _textTwo = _textFieldTwo.text;
    }
    else if(textField == _textFieldThree){
        _textThree = _textFieldThree.text;
    }
    else if(textField == _textFieldFour){
        _textFour = _textFieldFour.text;
    }
}

#pragma mark - Touch Handling Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_textFieldOne.isEditing){
        [_textFieldOne resignFirstResponder];
    }
    else if(_textFieldTwo.isEditing){
        [_textFieldTwo resignFirstResponder];
    }
    else if(_textFieldThree.isEditing){
        [_textFieldThree resignFirstResponder];
    }
    else if(_textFieldFour.isEditing){
        [_textFieldFour resignFirstResponder];
    }
}

#pragma mark - Memory Handling Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
