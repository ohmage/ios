//
//  OMHApplication.h
//  PAM
//
//  Created by Charles Forkish on 2/6/15.
//  Copyright (c) 2015 Charlie Forkish. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  We subclass UIApplication in order to intercept Google+ Sign In URL calls
 *  so we can present a custom web view instead of opening Safari
 *  http://stackoverflow.com/questions/15281386/google-iphone-api-sign-in-and-share-without-leaving-app/24577040#24577040
 */

#define ApplicationOpenGoogleAuthNotification @"ApplicationOpenGoogleAuthNotification"

@interface OMHApplication : UIApplication

@end
