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

- (void)drawBorderWithColor:(UIColor *)buttonColor{
    // Note -- This has no effect if using autolayout.
    // Add 20 to the frame in Storyboards if this is the case.
    self.frame = CGRectMake(self.frame.origin.x - 10, self.frame.origin.y,
                            self.frame.size.width + 20, self.frame.size.height);

    self.layer.borderColor = buttonColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4;
    
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
