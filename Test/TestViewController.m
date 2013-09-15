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

@implementation TestViewController{
    NSString *_textOne;
    NSString *_textTwo;
    NSString *_textThree;
    NSString *_textFour;
    
    UITextField *_textFieldOne;
    UITextField *_textFieldTwo;
    UITextField *_textFieldThree;
    UITextField *_textFieldFour;
}

#pragma mark - Init and Load Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadTextFields];
}

- (void) loadTextFields{
    _textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(104, 296, 200, 30)];
    _textFieldOne.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldOne.placeholder = @"TextFieldOne";
    _textFieldOne.delegate = self;
    [self.view addSubview:_textFieldOne];
    
    _textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(442, 296, 200, 30)];
    _textFieldTwo.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldTwo.placeholder = @"TextFieldTwo";
    _textFieldTwo.delegate = self;
    [self.view addSubview:_textFieldTwo];
    
    _textFieldThree = [[UITextField alloc] initWithFrame:CGRectMake(104, 372, 200, 30)];
    _textFieldThree.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldThree.placeholder = @"TextFieldThree";
    _textFieldThree.delegate = self;
    [self.view addSubview:_textFieldThree];
    
    _textFieldFour = [[UITextField alloc] initWithFrame:CGRectMake(442, 372, 200, 30)];
    _textFieldFour.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldFour.placeholder = @"TextFieldFour";
    _textFieldFour.delegate = self;
    [self.view addSubview:_textFieldFour];
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
