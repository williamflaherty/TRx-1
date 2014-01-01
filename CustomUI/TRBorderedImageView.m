//
//  TRBorderedImageView.m
//  TRx
//
//  Created by Mark Bellott on 10/27/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRBorderedImageView.h"

@implementation TRBorderedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawBorderWithColor:(UIColor *)borderColor{
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.5f;
    self.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0];
    
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
