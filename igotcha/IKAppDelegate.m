//
//  IKAppDelegate.m
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKAppDelegate.h"


#import "IKCameraViewController.h"
#import "IKTargetViewController.h"
#import "IKGotchaApi.h"
#import "IKLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "IKUserModel.h"
#import "IKPownedViewController.h"
#import "IKWinnerViewController.h"

@implementation IKAppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window.rootViewController = [[IKLoginViewController alloc] init];
    
    return YES;
}

- (void)showTabBarController
{
    UIViewController *cameraViewController, *targetViewController;
    
    targetViewController = [[IKTargetViewController alloc] init];
    cameraViewController = [[IKCameraViewController alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[cameraViewController, targetViewController];
    
    self.window.rootViewController = self.tabBarController;

    [self.tabBarController setSelectedIndex:1];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

// push stuff

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
//        NSLog(@"My token is: %@", deviceToken);
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];

    [IKGotchaApi registerToken:deviceTokenStr forUser:[IKUserModel sharedUserModel].profileId];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}




// hiding cancel buttons
//- (void)navigationController:(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    for (UINavigationItem *item in navigationController.navigationBar.subviews) {
//        if ([[item title] compare:@"Cancel"] == 0) {
//            UIButton *button = (UIButton *)item;
//            [button setHidden:YES];
//        }
//    }
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *discription = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    if([discription isEqualToString:@"You Won!"])
    {
        IKWinnerViewController *winnerViewController = [[IKWinnerViewController alloc] init];
        [self.tabBarController presentViewController:winnerViewController animated:YES completion:nil];
        
        [[IKUserModel sharedUserModel] updateFromServer];

    }
    else if ([discription isEqualToString:@"You've been GOT!"])
    {
        IKPownedViewController *pownedViewController = [[IKPownedViewController alloc] init];
        [self.tabBarController presentViewController:pownedViewController animated:YES completion:nil];
        
        [[IKUserModel sharedUserModel] updateFromServer];

    }
    else if ([discription isEqualToString:@"Game Started!"])
    {
        [[IKUserModel sharedUserModel] updateFromServer];
    }
    else if ([discription isEqualToString:@"Great Success!"])
    {
        [[IKUserModel sharedUserModel] updateFromServer];
    }
    else if ([discription isEqualToString:@"Nice Try!"])
    {
        [[IKUserModel sharedUserModel] updateFromServer];
    }
    
    
//    [self.window.rootViewController.navigationController presentedViewController:pownedViewController];
//    if ( application.applicationState == UIApplicationStateActive )
//    {
//        
//    }
//    else
//    {
//        // app was just brought from background to foreground
////        NSLog(@"%@", userInfo);
//    }


}


@end
