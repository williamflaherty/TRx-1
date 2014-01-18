//
//  TRCustomButton.m
//  TRx
//
//  Created by Mark Bellott on 1/5/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRCustomButton.h"

@implementation TRCustomButton

@synthesize isSelected = _isSelected;

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

- (void)drawButtonWithDefaultStyle{
    _isSelected = YES;
    self.layer.borderColor = [[UIApplication sharedApplication] keyWindow].tintColor.CGColor;
    self.layer.backgroundColor = [[UIApplication sharedApplication] keyWindow].tintColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 6;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setNeedsDisplay];
}

- (void)drawButtonWithCancelStlye{
    self.layer.borderColor = [UIColor colorWithRed:1.00 green:0.23 blue:0.18 alpha:1.0].CGColor;
    self.layer.backgroundColor = [UIColor colorWithRed:1.00 green:0.23 blue:0.18 alpha:1.0].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 6;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setNeedsDisplay];
}

- (void)selectButton{
    _isSelected = YES;
    self.layer.backgroundColor = [[UIApplication sharedApplication] keyWindow].tintColor.CGColor;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

- (void)deselectButton{
    _isSelected = NO;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self setTitleColor:[[UIApplication sharedApplication] keyWindow].tintColor forState:UIControlStateNormal];
    [self setNeedsDisplay];
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
