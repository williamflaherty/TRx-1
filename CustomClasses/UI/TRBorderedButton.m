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
//        self.frame = CGRectMake(self.frame.origin.x - 10, self.frame.origin.y,
//                                self.frame.size.width + 20, self.frame.size.height);
        self.layer.borderColor = [UIColor colorWithRed:(25.0/255) green:(148.0/255) blue:(251.0/255) alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 4;
        
    }
    return self;
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
