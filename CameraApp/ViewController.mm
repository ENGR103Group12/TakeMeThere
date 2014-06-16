//
//  ViewController.m
//  CameraApp
//
//  Created by John Wismer on 5/15/14.
//  Copyright (c) 2014 Group 12. All rights reserved.
//

#import "ViewController.h"
#import "LiveViewController.h"

@interface ViewController ()

@end

@implementation ViewController

{
    NSInteger pickedRadius;
}

@synthesize searchField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.radiusArray = [[NSArray alloc] initWithObjects:@"  1", @"  2", @"  3", @"  5", @" 10", @" 20", @" 30", @" 50", @"100", nil];
    searchField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 9;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    return [self.radiusArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    NSLog(@"Selected Row: %ld", (long)row);
    switch (row) {
        case 0:
            pickedRadius = 1;
            break;
        case 1:
            pickedRadius = 2;
            break;
        case 2:
            pickedRadius = 3;
            break;
        case 3:
            pickedRadius = 5;
            break;
        case 4:
            pickedRadius = 10;
            break;
        case 5:
            pickedRadius = 20;
            break;
        case 6:
            pickedRadius = 30;
            break;
        case 7:
            pickedRadius = 50;
            break;
        case 8:
            pickedRadius = 100;
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toLiveView"])
    {
        // Prepare for the transition before it happens
        LiveViewController *LVC = (LiveViewController *)segue.destinationViewController;
        LVC.searchText = searchField.text;
        LVC.radius = pickedRadius;
    }
}

@end
