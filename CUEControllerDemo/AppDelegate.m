//
//  AppDelegate.m
//  CUEControllerDemo
//
//  Created by Jameson Rader on 5/23/18.
//  Copyright © 2018 CUE Audio, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
// If fetching remote theme using ApiKeyService and CUEMultiDownloader, import these:
//#import <CUELive/CUEMultiDownloader.h>
//#import <CUELive/CUELive-Swift.h>

// CUE-BLE
#import <CUEBluetooth/CUEBroadcastClient.h>
#import <CUELive/CUEClientConfig.h>
#import <CUELive/CUELive-Swift.h>
#import <CUELive/CueNotificationsHelper.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate, CUETriggerReceiverDelegate>

@property CUEBroadcastClient *broadcastClient;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // To overwrite theme, insert Client Api Key here and uncomment the following code:
    // Note: If you pull your client API Key from the server, it should be cached (e.g., `UserDefaults`) so that the user can access the light show even without a network connection.
    /*
     [ApiKeyService setupWithApiKey:<#myClientApiKey#>];
     [CUEMultiDownloader fetchCUETheme];
     */
    
    // Reinstantiate CUEBroadcastClient if ID included
    NSArray *centralManagerIdentifiers = launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    if ([centralManagerIdentifiers containsObject: CUE_CENTRAL_MANAGER_ID]) {
        self.broadcastClient = [[CUEBroadcastClient alloc] initWithServiceUuid:[[CUEClientConfig sharedInstance] cueBroadcastServiceUuid]];
        self.broadcastClient.delegate = self;
        [self.broadcastClient start];
    }
    
    ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = viewController;
    
    return YES;
}

# pragma mark CUEBroadcastClient

- (void)didDetectTrigger:(nonnull NSString *) trigger {
    [[CueNotificationsHelper sharedInstance] handleDetectedBleTrigger:trigger];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    // Handle CUE BLE Notification
    UIWindow *window = self.window;
    if (window) {
        UIViewController *rootVc = window.rootViewController;
        if (rootVc) {
            if (rootVc) {
                [[CueNotificationsHelper sharedInstance] handleNotificationResponse: response withPresentingViewController: rootVc];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
