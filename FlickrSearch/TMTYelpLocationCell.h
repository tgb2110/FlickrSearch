//
//  TMTYelpLocationCell.h
//  FlickrSearch
//
//  Created by Troy Barrett on 7/28/14.
//  Copyright (c) 2014 TMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMFYelpLocation.h"

@interface TMTYelpLocationCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) TMFYelpLocation *location;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
