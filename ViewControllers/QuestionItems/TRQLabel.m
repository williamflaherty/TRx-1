//
//  TRQLabel.m
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "TRQLabel.h"

#define MIN_HEIGHT 10.0f
#define CONST_WIDTH 425.0f

@implementation TRQLabel

@synthesize minHeight = _minHeight;
@synthesize constrainedWidth = _constrainedWidth;

#pragma mark - Init and Load Methods

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _constrainedWidth = 0;
        
        self.minHeight = MIN_HEIGHT;
        self.frame = CGRectMake(0, 0, CONST_WIDTH, 100);
        
        [self setFont:[UIFont systemFontOfSize:20.0f]];
        [self setTextColor:[UIColor blackColor]];
        
        self.backgroundColor = [UIColor colorWithRed:200 green:200 blue:150 alpha:0];
        
    }
    return self;
}

#pragma mark - Sizing Methods

- (void) calculateSize{
    
    CGSize constraint;
    
    if(_constrainedWidth == 0){
        constraint = CGSizeMake(CONST_WIDTH, 20000.0f);
    }
    else{
        self.frame = CGRectMake(0, 0, _constrainedWidth, 100);
        constraint = CGSizeMake(_constrainedWidth, 20000.0f);
    }
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    [self setAdjustsFontSizeToFitWidth:NO];
    [self setNumberOfLines:0];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height)];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self calculateSize];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self calculateSize];
}



@end
