//
//  TestViewController.h
//  TRx
//
//  Created by Mark Bellott on 9/12/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, readonly) NSString *textOne;
@property(nonatomic, readonly) NSString *textTwo;
@property(nonatomic, readonly) NSString *textThree;
@property(nonatomic, readonly) NSString *textFour;

@property(nonatomic, readwrite) UITextField *textFieldOne;
@property(nonatomic, readwrite) UITextField *textFieldTwo;
@property(nonatomic, readwrite) UITextField *textFieldThree;
@property(nonatomic, readwrite) UITextField *textFieldFour;

@end
