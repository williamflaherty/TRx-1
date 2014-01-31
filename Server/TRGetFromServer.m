//
//  TRGetFromServer.m
//  TRx
//
//  Created by John Cotham on 1/28/14.
//  Copyright (c) 2014 TeamHaiti. All rights reserved.
//

#import "AFNetworking.h"
#import "TRGetFromServer.h"

@implementation TRGetFromServer

static NSString *host = nil;

+(void)initialize {
    host = @"http://54.201.222.7/";
}

+(void)getPatientList {
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
            NSLog(@"patient data: %@", patient);
            NSArray *imageSet = patient[@"image_set"];
            for (NSDictionary *image in imageSet) {
                if (image[@"isProfile"]) {
                    NSString *imageName = [NSString stringWithFormat:@"media/%@", image[@"record"]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", host, imageName]]];
                    
                    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        
                        //link to patient
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
