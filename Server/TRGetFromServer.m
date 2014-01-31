//
//  TRGetFromServer.m
//  TRx
//
//  Created by John Cotham on 1/28/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "AFNetworking.h"
#import "TRGetFromServer.h"
#import "CDPatient.h"
#import "CDImage.h"
#import "CDItem.h"
#import "CDItemList.h"
#import "TRManagedObjectContext.h"

@implementation TRGetFromServer

static NSString *host = nil;

+(void)initialize {
    host = @"http://54.201.222.7/";
}

+(void)getPatientList {
    
    /* MAKE SURE THAT DOCTORS AND SURGERY TYPES HAVE NOT CHANGED BETWEEN TRIPS. THE IDS MUST BE THE SAME */
    
    //create id => name dictionaries for doctors and surgeries
    
    
    TRManagedObjectContext *context = [TRManagedObjectContext mainThreadContext];
    
    
    NSOrderedSet *doctors = [CDItemList getList:@"DoctorList" inContext:context];
    NSLog(@"%@", doctors[0]);
    NSLog(@"%@", doctors);
    NSMutableDictionary *doctorDic = [[NSMutableDictionary alloc] init];
    for (CDItem *doctor in doctors) {
        NSLog(@"value: %@", [doctor valueForKey:@"value"]);
        NSLog(@"item_id: %@", [doctor valueForKey:@"item_id"]);
        doctorDic[doctor.item_id] = [doctor valueForKey:@"value"];
    }
    NSOrderedSet *surgeries = [CDItemList getList:@"SurgeryList" inContext:context];
    NSMutableDictionary *surgeryDic = [[NSMutableDictionary alloc] init];
    for (CDItem *surgery in surgeries) {
        surgeryDic[surgery.item_id] = surgery.value;
    }
    
    NSURL *url = [NSURL URLWithString:host];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient postPath:@"trx_app/get_patient_list/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if (!jsonData) {
            NSLog(@"Error serializing patient data into JSON: %@", error);
        }
        //jsonData contains keys exception, data, error, success
        
        NSArray *patients = jsonData[@"data"][@"patient"];
        for (NSDictionary *patient in patients) {
            //get patient data
            
            
            //create patient and set data
            CDPatient *p = [NSEntityDescription insertNewObjectForEntityForName:@"CDPatient"
                                                               inManagedObjectContext:context];
            p.firstName = patient[@"firstName"];
            p.lastName = patient[@"lastName"];
            p.hasTimeout = patient[@"hasTimeout"];
            
            p.isCurrent = patient[@"isCurrent"];
            p.middleName = patient[@"middleName"];
            //p.location = patient[@"location"];
            //p.surgeryType = [NSString stringWithFormat:@"%@", patient[@"surgeryType"]];
            //p.doctor = [NSString stringWithFormat:@"%@", patient[@"doctor"]];
            p.surgeryType = surgeryDic[patient[@"surgeryType"]]; // note that surgery type is an id
            p.doctor =  doctorDic[patient[@"doctor"]]; // note that doctor is an id
            
            
            //find profile image and set to patient's profile image
            NSArray *imageSet = patient[@"image_set"];
            for (NSDictionary *image in imageSet) {
                if (image[@"isProfile"]) {
                    
                    NSString *imageName = [NSString stringWithFormat:@"media/%@", image[@"record"]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", host, imageName]]];
                    
                    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        
                        CDImage *profileImage = [NSEntityDescription insertNewObjectForEntityForName:@"CDImage" inManagedObjectContext:context];
                        
                        //link image to patient
                        //converts from UIImage to NSData and may cause slowdown
                        profileImage.data = UIImageJPEGRepresentation(image, 1);
                        profileImage.belongsTo = p;
                        profileImage.belongsToProfile = p;
                        
                        //NSLog(@"%@", profileImage.data);
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        NSLog(@"Failed to retrieve profile image for patient: %@ %@", patient[@"firstName"], patient[@"lastName"]);
                        NSLog(@"error: %@", error);
                    }];
                    
                    [operation start];
                }
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to retrieve patient list: %@", error);
    }];
}





@end
