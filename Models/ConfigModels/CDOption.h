//
//  CDOption.h
//  TRx
//
//  Created by John Cotham on 1/14/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDQuestion, CDQuestionList;

@interface CDOption : NSManagedObject

@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSNumber * option_index;
@property (nonatomic, retain) NSString * display_text;
@property (nonatomic, retain) NSString * highlight;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) CDQuestion *question;
@property (nonatomic, retain) CDQuestionList *branchTo;

@end
