//
//  CDQuestion.h
//  TRx
//
//  Created by John Cotham on 1/23/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDOption, CDQuestionList;

@interface CDQuestion : NSManagedObject

@property (nonatomic, retain) NSString * display_group;
@property (nonatomic, retain) NSString * display_text;
@property (nonatomic, retain) NSNumber * list_index;
@property (nonatomic, retain) NSString * question_text;
@property (nonatomic, retain) NSString * question_type;
@property (nonatomic, retain) NSString * translation_text;
@property (nonatomic, retain) NSNumber * question_id;
@property (nonatomic, retain) CDQuestionList *list;
@property (nonatomic, retain) NSOrderedSet *options;
@end

@interface CDQuestion (CoreDataGeneratedAccessors)

- (void)addOptionsObject:(CDOption *)value;
- (void)removeOptionsObject:(CDOption *)value;
- (void)addOptions:(NSSet *)values;
- (void)removeOptions:(NSSet *)values;

@end
