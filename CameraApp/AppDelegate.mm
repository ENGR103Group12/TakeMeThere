//
//  AppDelegate.m
//  CameraApp
//
//  Created by John Wismer on 5/15/14.
//  Copyright (c) 2014 Group 12. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalFavoriteData.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    favoriteNames = [NSMutableArray arrayWithObjects:@" ", nil];
    [favoriteNames removeAllObjects];
    CLLocation *initLoc = [[CLLocation alloc] init];
    favoriteLocations = [NSMutableArray arrayWithObject:initLoc];
    [favoriteLocations removeAllObjects];
    
    NSArray *pathsFN = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPathFN = [pathsFN objectAtIndex:0];
    NSString *filePathFN = [documentsDirectoryPathFN stringByAppendingPathComponent:@"appDataFN"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathFN]) {
        NSData *dataFN = [NSData dataWithContentsOfFile:filePathFN];
        NSDictionary *savedDataFN = [NSKeyedUnarchiver unarchiveObjectWithData:dataFN];
        
        if ([savedDataFN objectForKey:@"favNames"] != nil) {
            favoriteNames = [[NSMutableArray alloc] initWithArray:[savedDataFN objectForKey:@"favNames"]];
        }
    }
    
    NSArray *pathsFL = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPathFL = [pathsFL objectAtIndex:0];
    NSString *filePathFL = [documentsDirectoryPathFL stringByAppendingPathComponent:@"appDataFL"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathFL]) {
        NSData *dataFL = [NSData dataWithContentsOfFile:filePathFL];
        NSDictionary *savedDataFL = [NSKeyedUnarchiver unarchiveObjectWithData:dataFL];
        
        if ([savedDataFL objectForKey:@"favLocs"] != nil) {
            favoriteLocations = [[NSMutableArray alloc] initWithArray:[savedDataFL objectForKey:@"favLocs"]];
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveData];
}

- (void) saveData {
    NSMutableDictionary *dataDictFN = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (favoriteNames != nil) {
        [dataDictFN setObject:favoriteNames forKey:@"favNames"];  // save the games array
    }
    
    NSArray *pathsFN = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPathFN = [pathsFN objectAtIndex:0];
    NSString *filePathFN = [documentsDirectoryPathFN stringByAppendingPathComponent:@"appDataFN"];
    
    [NSKeyedArchiver archiveRootObject:dataDictFN toFile:filePathFN];
    
    NSMutableDictionary *dataDictFL = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (favoriteLocations != nil) {
        [dataDictFL setObject:favoriteLocations forKey:@"favLocs"];  // save the games array
    }
    
    NSArray *pathsFL = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPathFL = [pathsFL objectAtIndex:0];
    NSString *filePathFL = [documentsDirectoryPathFL stringByAppendingPathComponent:@"appDataFL"];
    
    [NSKeyedArchiver archiveRootObject:dataDictFL toFile:filePathFL];
}

@end
