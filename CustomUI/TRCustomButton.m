//
//  TRCustomButton.m
//  TRx
//
//  Created by Mark Bellott on 1/5/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRCustomButton.h"

@implementation TRCustomButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    }
    return self;
}

- (void)drawButtonWithColor:(UIColor *)buttonColor{
    
    self.layer.borderColor = buttonColor.CGColor;
    self.layer.backgroundColor = buttonColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 6;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setNeedsDisplay];
}

- (void)drawButtonWithSubmitStyle{
    
}

- (void)drawButtonWithCancelStlye{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
