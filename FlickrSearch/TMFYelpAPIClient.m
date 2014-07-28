//
//  TMFYelpAPIClient.m
//  corelocationPractice
//
//  Created by Tarik Fayad on 7/28/14.
//  Copyright (c) 2014 Tarik Fayad. All rights reserved.
//

#import "TMFYelpAPIClient.h"
#import "OAuthConsumer.h"

NSString *const CONSUMER_KEY = @"Qv2juF5Td1VYLYmWvZ30PA";
NSString *const CONSUMER_SECRET = @"cXpBB5DPDEwuofi_FkyGCZ-x42Q";
NSString *const TOKEN = @"7V1I7fWNZ2hVHcHqt6RlPyuf0N7frr9E";
NSString *const TOKEN_SECRET = @"TlOeGtZdmOOUZyh-ILGDDHZOPis";

@implementation TMFYelpAPIClient

+ (void) fetchYelpLocationsWithCompletion:(void (^)(NSDictionary *))completionBlock
{
    NSURL *url= [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=restaurants&location=new%20york"];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:CONSUMER_KEY secret:CONSUMER_SECRET];
    OAToken *token = [[OAToken alloc] initWithKey:TOKEN secret:TOKEN_SECRET];
    
    id <OASignatureProviding, NSObject> provider = [OAHMAC_SHA1SignatureProvider new];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]
                                    initWithURL:url
                                    consumer:consumer
                                    token:token
                                    realm:nil
                                    signatureProvider:provider];
    
    [request prepare];
    
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *locations = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        completionBlock (locations);
    }];
    
    [task resume];
}

+ (void) fetchYelpLocationsAtLatitude: (NSString *)latitude andLongitude: (NSString *)longitude withCompletion:(void (^)(NSDictionary *locations))completionBlock
{
    NSMutableString *urlString = [@"http://api.yelp.com/v2/search?term=restaurants" mutableCopy];
    [urlString appendString:[NSString stringWithFormat:@"&ll=%@,%@", latitude, longitude]];
    NSURL *url = [NSURL URLWithString: urlString];

    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:CONSUMER_KEY secret:CONSUMER_SECRET];
    OAToken *token = [[OAToken alloc] initWithKey:TOKEN secret:TOKEN_SECRET];

    id <OASignatureProviding, NSObject> provider = [OAHMAC_SHA1SignatureProvider new];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]
                                    initWithURL:url
                                    consumer:consumer
                                    token:token
                                    realm:nil
                                    signatureProvider:provider];

    [request prepare];


    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *locations = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        completionBlock (locations);
    }];

    [task resume];
}

@end
