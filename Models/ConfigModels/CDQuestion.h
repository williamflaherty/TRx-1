//
//  Question.h
//  TRx
//
//  Created by John Cotham on 1/12/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDQuestion : NSManagedObject

@property (nonatomic, retain) NSNumber * list_index;
@property (nonatomic, retain) NSString * display_group;
@property (nonatomic, retain) NSString * display_text;
@property (nonatomic, retain) NSString * question_text;
@property (nonatomic, retain) NSString * question_type;
@property (nonatomic, retain) NSString * translation_text;
@property (nonatomic, retain) NSManagedObject *list;
@property (nonatomic, retain) NSOrderedSet *options;

@end
