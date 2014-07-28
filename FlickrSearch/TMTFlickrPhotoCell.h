//
//  TMTFlickrPhotoCell.h
//  FlickrSearch
//
//  Created by Troy Barrett on 7/28/14.
//  Copyright (c) 2014 TMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FlickrPhoto;

@interface TMTFlickrPhotoCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) FlickrPhoto *photo;

@end
