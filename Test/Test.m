//
//  Test.m
//  TRx
//
//  Created by Mark Bellott on 9/11/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import "Test.h"

@interface Test ()

@end

@implementation Test

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
        _textOne = @"";
        _textTwo = @"";
        _textThree = @"";
        _textFour = @"";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - UITextFiedDelegate Methods


#pragma mark - Touch Handling Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textFieldOne resignFirstResponder];
    [_textFieldTwo resignFirstResponder];
    [_textFieldThree resignFirstResponder];
    [_textFieldFour resignFirstResponder];
}

#pragma mark - Memory Handling Methods

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
