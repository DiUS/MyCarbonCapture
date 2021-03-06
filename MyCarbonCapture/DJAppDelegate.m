//
//  DJAppDelegate.m
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import "DJAppDelegate.h"

#import "DJTreeContainer.h"
#import "DJWifiUsageModel.h"

@implementation DJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  DJTreeContainer *treeContainer = [[DJTreeContainer alloc] initWithNibName:nil bundle:nil];
  self.moc = [DJCoredataStack createNewCoreDataStack];
  treeContainer.moc = self.moc;

  NSLog(@"The MOC is %@",treeContainer.moc);
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:treeContainer];
  [self.window addSubview:nav.view];
  self.window.rootViewController = nav;
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  NSError *error = nil;
  [self.moc save:&error];
  if (error) {
    NSLog(@"Error saving the MOC %@",error.userInfo);
  }
  [[NSUserDefaults standardUserDefaults] synchronize];
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [[NSUserDefaults standardUserDefaults] synchronize];

  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  [[DJWifiUsageModel sharedInstance] refreshNetworkStats];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
