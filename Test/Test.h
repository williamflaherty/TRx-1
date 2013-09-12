//
//  Test.h
//  TRx
//
//  Created by Mark Bellott on 9/11/13.
//  Copyright (c) 2013 Team Haiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Test : UIViewController <UITextFieldDelegate>

@property(nonatomic, readonly) NSString *textOne;
@property(nonatomic, readonly) NSString *textTwo;
@property(nonatomic, readonly) NSString *textThree;
@property(nonatomic, readonly) NSString *textFour;

@property(nonatomic, readwrite) IBOutlet UITextField *textFieldOne;
@property(nonatomic, readwrite) IBOutlet UITextField *textFieldTwo;
@property(nonatomic, readwrite) IBOutlet UITextField *textFieldThree;
@property(nonatomic, readwrite) IBOutlet UITextField *textFieldFour;

@end
