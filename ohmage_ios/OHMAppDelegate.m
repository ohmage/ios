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

#import "OMHClient.h"

@interface OHMAppDelegate ()

@property (nonatomic, strong) OHMLoginViewController *loginViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation OHMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [OMHClient setupClientWithAppGoogleClientID:kOhmageGoogleClientID
                           serverGoogleClientID:kOMHServerGoogleClientID
                                 appDSUClientID:kOhmageDSUClientID
                             appDSUClientSecret:kOhmageDSUClientSecret];
    
    //TODO: remove
    [OMHClient setDSUBaseURL:@"https://lifestreams.smalldata.io/dsu"];
    
    if (![OMHClient sharedClient].isSignedIn) {
        self.window.rootViewController = self.loginViewController;
    }
    else {
        self.window.rootViewController = self.navigationController;
        
        // handle reminder notification
        UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (notification != nil) {
            OHMSurveysViewController *vc = [[(UINavigationController *)self.window.rootViewController viewControllers] firstObject];
            [vc handleSurveyReminderNotification:notification];
            [[OHMReminderManager sharedReminderManager] processFiredLocalNotification:notification];
        }
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 *  application:didReceiveLocalNotification
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
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
    else {
        UIViewController *vc = self.navigationController.viewControllers.firstObject;
        if ([vc isKindOfClass:[OHMSurveysViewController class]]) {
            [(OHMSurveysViewController *)vc handleSurveyReminderNotification:notification];
        }
    }
    
    [[OHMReminderManager sharedReminderManager] processFiredLocalNotification:notification];
}

/**
 *  application:handleEventsForBackgroundURLSession
 */
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
}

/**
 *  applicationWillResignActive
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[OHMModel sharedModel] saveModelState];
}

/**
 *  applicationDidBecomeActive
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[OHMReminderManager sharedReminderManager] synchronizeReminders];
}

- (OHMLoginViewController *)loginViewController
{
    if (_loginViewController == nil) {
        _loginViewController = [[OHMLoginViewController alloc] init];
    }
    return _loginViewController;
}

- (UINavigationController *)navigationController
{
    if (_navigationController == nil) {
        OHMSurveysViewController *vc = [[OHMSurveysViewController alloc] init];
        UINavigationController *navcon = [[UINavigationController alloc] initWithRootViewController:vc];
        _navigationController = navcon;
    }
    return _navigationController;
}


#pragma mark - Login

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    NSLog(@"openURL: %@, source: %@, annotation: %@", url, sourceApplication, annotation);
    return [[OMHClient sharedClient] handleURL:url
                             sourceApplication:sourceApplication
                                    annotation:annotation];
}

- (void)userDidLogin
{
    UINavigationController *newRoot = self.navigationController;
    [UIView transitionFromView:self.loginViewController.view toView:newRoot.view duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        self.window.rootViewController = newRoot;
        self.loginViewController = nil;
        [[OHMLocationManager sharedLocationManager] requestAuthorization];
    }];
}

@end
