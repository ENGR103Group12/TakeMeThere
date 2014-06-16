//
//  ViewController.h
//  CameraApp
//
//  Created by John Wismer on 5/15/14.
//  Copyright (c) 2014 Group 12. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <PanicARKit/PanicARKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIPickerView *radiusPicker;

@property (strong, nonatomic) NSArray *radiusArray;

@end
