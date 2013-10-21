//
//  TRPatientListCell.h
//  TRx
//
//  Created by Mark Bellott on 9/22/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPatientListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *patientCellPhoto;
@property (weak, nonatomic) IBOutlet UILabel *patientCellName;
@property (weak, nonatomic) IBOutlet UILabel *patientCellComplaint;

@end
