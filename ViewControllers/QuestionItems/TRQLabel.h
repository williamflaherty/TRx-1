//
//  TRQLabel.h
//  TRx
//
//  Created by Mark Bellott on 1/1/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRQLabel : UILabel

@property(nonatomic) float minHeight;
@property(nonatomic, readwrite) float constrainedWidth;

-(void) calculateSize;

@end
