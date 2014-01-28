//
//  TRQCheckBox.m
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRQCheckBox.h"

@implementation TRQCheckBox

@synthesize toggleCount = _toggleCount;
@synthesize optionValue = _optionValue;
@synthesize arrayIndex = _arrayIndex;

#pragma mark - Init and Load Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _toggleCount = 0;
        _arrayIndex = 0;
        
        self.frame = CGRectMake(0, 0, 20, 20);
        [self drawButtonWithDefaultStyle];
        [self deselectButton];
        
    }
    return self;
}

-(void) setArrayIndex:(NSInteger)a{
    _arrayIndex = a;
}

-(void) checkPressed{
    if(_toggleCount == 0){
        [self selectButton];
        _toggleCount++;
    }
    else{
        [self deselectButton];
        _toggleCount--;
    }
}


@end
