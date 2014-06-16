//
//  LiveViewController.h
//  CameraApp
//
//  Created by John Wismer on 6/1/14.
//  Copyright (c) 2014 Group 12. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <PanicARKit/PanicARKit.h>

@interface LiveViewController : PARViewController <PARControllerDelegate, UIActionSheetDelegate,MKMapViewDelegate>

@property (strong, nonatomic) NSString *searchText;
@property NSInteger radius;

@end
