//
//  TRQCheckBox.h
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRCustomButton.h"

@interface TRQCheckBox : TRCustomButton

@property (nonatomic, readonly) NSInteger toggleCount;
@property (nonatomic, retain) NSString * optionValue;
@property (nonatomic, readwrite) NSInteger arrayIndex;

- (void)checkPressed;

@end
