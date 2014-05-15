//
//  OHMAppDelegate.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/7/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMAppDelegate.h"
#import "OHMSurveysViewController.h"
#import "OHMLoginViewController.h"
#import "OHMReminderManager.h"
#import "OHMLocationManager.h"

@implementation OHMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    OHMSurveysViewController * vc = [[OHMSurveysViewController alloc] initWithOhmletIndex:0];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (![[OHMClient sharedClient] hasLoggedInUser]) {
        [self.window.rootViewController presentViewController:[[OHMLoginViewController alloc] init] animated:NO completion:nil];
    }
    else {
        UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        NSLog(@"Application launched with local notification: %@", notification);
        if (notification != nil) {
            [[OHMReminderManager sharedReminderManager] processFiredLocalNotification:notification];
        }
        
        if ([CLLocationManager locationServicesEnabled])
        {
            OHMLocationManager *appLocationManager = [OHMLocationManager sharedLocationManager];
            [appLocationManager.locationManager startUpdatingLocation];
        }
    }
    
    return YES;
}

/**
 *  application:didReceiveLocalNotification
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Application did receive local notification: %@", notification);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // If we're the foreground application, then show an alert view as one would not have been
        // presented to the user via the notification center.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                            message:notification.alertBody
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    }
    
    [[OHMReminderManager sharedReminderManager] processFiredLocalNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[OHMClient sharedClient] saveClientState];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[OHMReminderManager sharedReminderManager] updateRemindersForFiredNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
