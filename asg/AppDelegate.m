//
//  AppDelegate.m
//  asg
//
//  Created by Rey Jenald Peña on 2/9/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Global.h"
#import "Constants.h"
#import "ASWorksiteViewController.h"
#import "ASLoginViewController.h"
#import "ASRootController.h"
#import "ASRootController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"mOFprPo66toEuSTFIpoWI4rkOu3ZZ6Q8ZAeA31aF"
                  clientKey:@"9KCIXpkkbCQewq9bPK9OLSej9c2CLNGoqlC9g4ZG"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([PFUser currentUser] == nil) {
        ASLoginViewController *loginViewController = (ASLoginViewController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_LOGIN_VC_IDENTIFIER];
        self.window.rootViewController = loginViewController;
    } else {
        ASRootController *worksiteViewController = (ASRootController *)[Global loadViewControllerFromStoryboardIdentifier:ASG_ROOT_VC_IDENTIFIER];
        self.window.rootViewController = worksiteViewController;
        [[Global sharedInstance] checkUserTimeInStatus];
    }
    
    [Global isCurrentUserManager:^(BOOL isManager) {
        [[Global sharedInstance] setIsManager:isManager];
    }];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
