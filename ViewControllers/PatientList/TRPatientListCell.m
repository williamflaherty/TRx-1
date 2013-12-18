//
//  TRPatientListCell.m
//  TRx
//
//  Created by Mark Bellott on 9/22/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRPatientListCell.h"

@implementation TRPatientListCell

@synthesize patientCellPhoto = _patientCellPhoto;
@synthesize patientCellName = _patientCellName;
@synthesize patientCellComplaint = _patientCellComplaint;
@synthesize patientCellBirthdate = _patientCellBirthdate;

#pragma mark Init and Load Methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setUpCellItems{
    _patientCellPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 150, 150)];
    
    _patientCellName = [[UILabel alloc] initWithFrame:CGRectMake(231, 15, 504, 55)];
    _patientCellName.font = [UIFont systemFontOfSize:46.0];
    
    _patientCellComplaint = [[UILabel alloc] initWithFrame:CGRectMake(231, 79, 504, 21)];
    _patientCellComplaint.font = [UIFont systemFontOfSize:17.0];
    
    _patientCellBirthdate = [[UILabel alloc] initWithFrame:CGRectMake(231, 108, 504, 21)];
    _patientCellBirthdate.font = [UIFont systemFontOfSize:17.0];
    
    [self.contentView addSubview:_patientCellPhoto];
    [self.contentView addSubview:_patientCellName];
    [self.contentView addSubview:_patientCellComplaint];
    [self.contentView addSubview:_patientCellBirthdate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
