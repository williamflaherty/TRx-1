//
//  TRPatientListCell.h
//  TRx
//
//  Created by Mark Bellott on 9/22/13.
//  Copyright (c) 2013 TeamHaiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPatientListCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UIImageView *patientCellPhoto;
@property(nonatomic,strong) IBOutlet UILabel *patientCellName;
@property(nonatomic,strong) IBOutlet UILabel *patientCellComplaint;

@end
