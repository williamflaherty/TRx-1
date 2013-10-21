//
//  TRPatientListCell.m
//  TRx
//
//  Created by Mark Bellott on 9/22/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import "TRPatientListCell.h"

@implementation TRPatientListCell

@synthesize patientCellPhoto = _patientCellPhoto,
patientCellName = _patientCellName,
patientCellComplaint = _patientCellComplaint;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
