//
//  TRPatientListCell.m
//  TRx
//
//  Created by Mark Bellott on 9/22/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRPatientListCell.h"

@implementation TRPatientListCell{
    UILabel *_complaintLabel;
    UILabel *_birthdateLabel;
}

#pragma mark Init and Load Methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setUpCellItems{
    _patientCellPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _patientCellName = [[UILabel alloc] initWithFrame:CGRectZero];
    _patientCellName.font = [UIFont systemFontOfSize:46.0];
    
    _complaintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _complaintLabel.font = [UIFont systemFontOfSize:17.0];
    _complaintLabel.text = @"Complaint:";
    
    _patientCellComplaint = [[UILabel alloc] initWithFrame:CGRectZero];
    _patientCellComplaint.font = [UIFont systemFontOfSize:17.0];
    
    _birthdateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _birthdateLabel.font = [UIFont systemFontOfSize:17.0];
    _birthdateLabel.text = @"Birthdate:";
    
    _patientCellBirthdate = [[UILabel alloc] initWithFrame:CGRectZero];
    _patientCellBirthdate.font = [UIFont systemFontOfSize:17.0];
    
    [self.contentView addSubview:_patientCellPhoto];
    [self.contentView addSubview:_patientCellName];
    [self.contentView addSubview:_complaintLabel];
    [self.contentView addSubview:_patientCellComplaint];
    [self.contentView addSubview:_birthdateLabel];
    [self.contentView addSubview:_patientCellBirthdate];
    
    [self resizeFrames];
}

- (void)resizeFrames{
    _patientCellPhoto.frame = CGRectMake(20, 15, 150, 150);
    _patientCellName.frame = CGRectMake(231, 15, 504, 55);
    _birthdateLabel.frame = CGRectMake(231, 108, 86, 21);
    _complaintLabel.frame = CGRectMake(231, 79, 86, 21);
    _patientCellComplaint.frame = CGRectMake(325, 79, 410, 21);
    _patientCellBirthdate.frame = CGRectMake(325, 108, 410, 21);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
