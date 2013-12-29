//
//  TRBorderedButton.m
//  TRx
//
//  Created by Mark Bellott on 10/26/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRBorderedButton.h"

@implementation TRBorderedButton

- (id)initWithFrame:(CGRect)frame
{
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

- (void)drawBorderWithColor:(UIColor *)borderColor{
    //Note: Due to Autotlayout no changes can be made to the frame here.
    //It is recomended you add 20 to your buttons width.

    self.titleLabel.textColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.backgroundColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 6;
    
    [self setNeedsDisplay];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
