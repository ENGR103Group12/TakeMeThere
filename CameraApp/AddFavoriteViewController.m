//
//  AddFavoriteViewController.m
//  CameraApp
//
//  Created by John Wismer on 6/14/14.
//  Copyright (c) 2014 Group 12. All rights reserved.
//

#import "AddFavoriteViewController.h"
#import "GlobalFavoriteData.h"

@interface AddFavoriteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewAFVC;

- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;


@end

@implementation AddFavoriteViewController

@synthesize mapViewAFVC;

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
    [_nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButton:(id)sender {
    [favoriteNames addObject:_nameTextField.text];
    CLLocation *uLoc = [[CLLocation alloc] initWithLatitude:mapViewAFVC.userLocation.coordinate.latitude longitude:mapViewAFVC.userLocation.coordinate.longitude];
    [favoriteLocations addObject:uLoc];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
