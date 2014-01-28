//
//  TRHistoryViewController.h
//  TRx
//
//  Created by Mark Bellott on 10/26/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRQView;

@interface TRHistoryViewController : UIViewController
< UITextFieldDelegate,
UIAlertViewDelegate >

@property (nonatomic, retain) TRQView *mainQuestion;
@property (nonatomic, retain) TRQView *translatedQuestion;

@end
