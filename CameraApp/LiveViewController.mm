//
//  LiveViewController.m
//  CameraApp
//
//  Created by John Wismer on 6/1/14.
//  Copyright (c) 2014 Group 12. All rights reserved.
//

#import "LiveViewController.h"
#import "GlobalFavoriteData.h"

@interface LiveViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *optionsView;
@property (weak, nonatomic) IBOutlet UISwitch *searchOnOff;
@property (weak, nonatomic) IBOutlet UISwitch *favoritesOnOff;

- (IBAction)optionsButton:(id)sender;
- (IBAction)searchResultsSwitch:(id)sender;
- (IBAction)favoritesSwitch:(id)sender;

@end

@implementation LiveViewController

{
    CLLocation *userLocation;
    CLLocationCoordinate2D *location;
}

@synthesize map;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    map.showsUserLocation = YES;
    
    //[self performLocalSearch];
    
    //[self performSelector:@selector(performLocalSearch) withObject:@" " afterDelay:3];
    //[self performSelector:@selector(displayFavorites) withObject:@" " afterDelay:4];
    
    [[PARController sharedARController] clearObjects];
    
    [_optionsView.layer setCornerRadius:20.0f];
    _optionsView.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //[[PARController sharedARController] clearObjects];
    
    [self performSelector:@selector(displayFavorites) withObject:@" " afterDelay:2];
    [self performSelector:@selector(performLocalSearch) withObject:@" " afterDelay:3];
    
    _locationLabel.text = [NSString stringWithFormat:@"Location: %.2f, %.2f", map.userLocation.coordinate.latitude, map.userLocation.coordinate.longitude];
    
    NSLog(@"View Appeared");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Configure the ARView
- (BOOL)usesCameraPreview {
    return YES;
}
- (BOOL)fadesInCameraPreview {
    return NO;
}
- (BOOL)rotatesARView {
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    userLocation = [locations lastObject];
}

- (UIImage *) changeColor: (UIImage *)image heatValue:(double)val {
    UIGraphicsBeginImageContext(image.size);
    
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    // Retrieve source image and begin image context
    CGSize itemImageSize = [image size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
    
    UIGraphicsBeginImageContext(contextRect.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [image CGImage]);
    
    
    CGContextSetRGBFillColor(c, 1, val, 0, 0.8);
    
    contextRect.size.height = -contextRect.size.height;
    contextRect.size.height -= 15;
    // Fill and end the transparency layer
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void) performLocalSearch{
    
    [map removeAnnotations:[map annotations]];
    //[[PARController sharedARController] clearObjects];
    
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    searchRequest.naturalLanguageQuery = _searchText;
    
    MKCoordinateRegion searchRegion = MKCoordinateRegionMakeWithDistance(map.userLocation.coordinate, (_radius*1609.0), (_radius*1609.0));
    searchRequest.region = searchRegion;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem *item in response.mapItems) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = item.name;
            annotation.coordinate = item.placemark.coordinate;
            
            [map addAnnotation:annotation];
             
            CLLocation *aLoc = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
            CLLocation *uLoc = [[CLLocation alloc] initWithLatitude:map.userLocation.coordinate.latitude longitude:map.userLocation.coordinate.longitude];
            
            CLLocationDistance distVal = [uLoc distanceFromLocation:aLoc];
            
            if (annotation.title.length < 10) {
                CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
                PARPoiLabel* newLabel = [[PARPoiLabel alloc] initWithTitle:annotation.title theDescription:@" " theImage:[self changeColor:[UIImage imageNamed:@"Marker"] heatValue:distVal/(_radius*1609.0)] atLocation:newLocation];
                [[PARController sharedARController] addObject:newLabel];
            }else{
                CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
                PARPoiLabel* newLabel = [[PARPoiLabel alloc] initWithTitle:[annotation.title substringToIndex:10] theDescription:@" " theImage:[self changeColor:[UIImage imageNamed:@"Marker"] heatValue:distVal/(_radius*1609.0)] atLocation:newLocation];
                [[PARController sharedARController] addObject:newLabel];
            }
        }
    }
     ];
}

- (void) displayFavorites{
    // Add favorites to view
    int i = 0;
    for (CLLocation *favLoc in favoriteLocations) {
        CLLocation *aLoc = [[CLLocation alloc] initWithLatitude:favLoc.coordinate.latitude longitude:favLoc.coordinate.longitude];
        CLLocation *uLoc = [[CLLocation alloc] initWithLatitude:map.userLocation.coordinate.latitude longitude:map.userLocation.coordinate.longitude];
        
        CLLocationDistance distVal = [uLoc distanceFromLocation:aLoc];
        
        if ([[favoriteNames objectAtIndex:i] length] < 10) {
            CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:favLoc.coordinate.latitude longitude:favLoc.coordinate.longitude];
            PARPoiLabel* newLabel = [[PARPoiLabel alloc] initWithTitle:[favoriteNames objectAtIndex:i] theDescription:@" " theImage:[self changeColor:[UIImage imageNamed:@"Marker"] heatValue:distVal/(_radius*1609.0)] atLocation:newLocation];
            [[PARController sharedARController] addObject:newLabel];
        }else{
            CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:favLoc.coordinate.latitude longitude:favLoc.coordinate.longitude];
            PARPoiLabel* newLabel = [[PARPoiLabel alloc] initWithTitle:[[favoriteNames objectAtIndex:i] substringToIndex:10] theDescription:@" " theImage:[self changeColor:[UIImage imageNamed:@"Marker"] heatValue:distVal/(_radius*1609.0)] atLocation:newLocation];
            [[PARController sharedARController] addObject:newLabel];
        }
        i++;
    }
}

- (void)arDidTapObject:(id<PARObjectDelegate>)object{
    NSLog(@"%@ was tapped.", object.title);
    [self performSegueWithIdentifier:@"toLabelWebsite" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toLabelWebsite"]) {
        //
    }
}

- (IBAction)optionsButton:(id)sender {
    if (_optionsView.hidden == YES) {
        _optionsView.hidden = NO;
    }else{
        _optionsView.hidden = YES;
    }
}

- (IBAction)searchResultsSwitch:(id)sender {
    if (self.searchOnOff.on) {
        // Add search results to view
        [self performLocalSearch];
    }else{
        [[PARController sharedARController] clearObjects];
        if (self.favoritesOnOff.on) {
            [self displayFavorites];
        }
    }
}

- (IBAction)favoritesSwitch:(id)sender {
    if (self.favoritesOnOff.on) {
        // Add favorites to view
        [self displayFavorites];
    }else{
        // clear favorites from view
        [[PARController sharedARController] clearObjects];
        if (self.searchOnOff.on) {
            [self performLocalSearch];
        }
    }
}
@end
