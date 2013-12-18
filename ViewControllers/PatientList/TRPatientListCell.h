//
//  TRPatientListCell.h
//  TRx
//
//  Created by Mark Bellott on 9/22/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPatientListCell : UITableViewCell

//Properties
@property(nonatomic,strong) UIImageView *patientCellPhoto;
@property(nonatomic,strong) UILabel *patientCellName;
@property(nonatomic,strong) UILabel *patientCellComplaint;
@property(nonatomic,strong) UILabel *patientCellBirthdate;

//Methods
- (void)setUpCellItems;

@end
