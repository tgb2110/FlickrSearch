//
//  TMTViewController.m
//  FlickrSearch
//
//  Created by Troy Barrett on 7/28/14.
//  Copyright (c) 2014 TMT. All rights reserved.
//

#import "TMTViewController.h"
#import "TMTDetailsViewController.h"
#import "TMFYelpAPIClient.h"
#import "TMFYelpLocation.h"
#import "TMTYelpLocationCell.h"

@interface TMTViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;

- (IBAction)shareButtonTapped:(id)sender;

@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property (strong, nonatomic) TMFYelpLocation *yelpManager;

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation TMTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.yelpLocations = [NSMutableArray new];
    self.locationManager = [CLLocationManager new];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.startLocation = nil;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [self.toolbar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.textField setBackground:textFieldImage];
    
    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    self.yelpManager = [[TMFYelpLocation alloc] init];
    
    //[self.collectionView registerClass:[TMTFlickrPhotoCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.locationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)shareButtonTapped:(id)sender {
    // TODO
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    // 1
    //    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
//        if(results && [results count] > 0) {
//            // 2
//            if(![self.searches containsObject:searchTerm]) {
//                NSLog(@"Found %d photos matching %@", [results count],searchTerm);
//                [self.searches insertObject:searchTerm atIndex:0];
//                self.searchResults[searchTerm] = results; }
//            // 3
//            dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.collectionView reloadData];
//            });
//        } else { // 1
//            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
//        } }];
//    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Core Location Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    if (locations.count > 1) {
        oldLocation = [locations objectAtIndex:locations.count-2];
    }
    
    NSString *latitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    [TMFYelpAPIClient fetchYelpLocationsAtLatitude: latitude andLongitude:longitude withCompletion:^(NSDictionary *locations) {
        NSArray *businesses = locations[@"businesses"];
        for (NSInteger i = 0; i < businesses.count; i++) {
            TMFYelpLocation *location = [TMFYelpLocation new];
            location.name = businesses[i][@"name"];
            location.imageURL = [NSURL URLWithString:businesses[i][@"image_url"]];
            
            [self.yelpLocations addObject:location];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.yelpLocations count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TMTYelpLocationCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    TMFYelpLocation *location = self.yelpLocations[indexPath.row];
    cell.location = location;
    cell.imageView.image = location.locationImage;
    cell.name.text = location.name;
    
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: selected item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMFYelpLocation *location = self.yelpLocations[indexPath.row];

    location.locationImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location.imageURL]];

    // 2
    CGSize retval = CGSizeMake(200, 200);
    retval.height += 35;
    retval.width += 35;
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TMTYelpLocationCell *locationCell = sender;
    
    TMFYelpLocation *location = locationCell.location;
    
    TMTDetailsViewController *nextVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        nextVC.location = location;
    }
}































@end
