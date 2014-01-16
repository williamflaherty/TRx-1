//
//  TRCustomButton.h
//  TRx
//
//  Created by Mark Bellott on 1/5/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRCustomButton : UIButton

@property (nonatomic, readwrite) BOOL isSelected;

- (void)drawButtonWithDefaultStyle;
- (void)drawButtonWithCancelStlye;

- (void)selectButton;
- (void)deselectButton;

@end
