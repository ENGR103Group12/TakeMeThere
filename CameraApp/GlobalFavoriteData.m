//
//  GlobalFavoriteData.m
//  CameraApp
//
//  Created by John Wismer on 6/14/14.
//  Copyright (c) 2014 Group 12. All rights reserved.
//

#import "GlobalFavoriteData.h"

@implementation GlobalFavoriteData

NSMutableArray *favoriteNames;
NSMutableArray *favoriteLocations;

+ (void)initFavoriteNames
{
    favoriteNames = [[NSMutableArray alloc] initWithObjects:@" ", nil];
}

@end
