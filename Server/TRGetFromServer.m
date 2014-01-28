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
    host = @"http://54.201.222.7/trx_app/";
}

+(void)getPatientList {
    NSURL *url = [NSURL URLWithString:host];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient postPath:@"get_patient_list/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to retrieve patient list: %@", error);
    }];
}


/*
+(NSArray *)getPatientList {
    NSString *encodedString = [NSString stringWithFormat:@"%@get_patient_list/", host];
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        return jsonArray;
    }
    NSLog(@"getPatientList didn't work: error in PHP");
    return NULL;
}
*/


@end
