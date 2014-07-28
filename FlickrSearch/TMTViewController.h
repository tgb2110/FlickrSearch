//
//  TMTViewController.h
//  FlickrSearch
//
//  Created by Troy Barrett on 7/28/14.
//  Copyright (c) 2014 TMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TMFYelpLocation.h"

@interface TMTViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) NSInteger selectedPhotoIndex;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *startLocation;


@property (strong, nonatomic) NSMutableArray *yelpLocations;

@end
