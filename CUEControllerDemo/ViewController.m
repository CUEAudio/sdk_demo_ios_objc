//
//  ViewController.m
//  CUEControllerDemo
//
//  Created by Jameson Rader on 5/23/18.
//  Copyright © 2018 CUE Audio, LLC. All rights reserved.
//

#import "ViewController.h"
#import <CUEControllerDemo-Swift.h>

// If using CUE BLE, import the following
#import <CUEBluetooth/CUEBroadcastClient.h>
#import <CUELive/CUEClientConfig.h>
#import <CUELive/CueNotificationsHelper.h>

@interface ViewController() <CUETriggerReceiverDelegate>

// If using CUE BLE, add this property
@property CUEBroadcastClient *broadcastClient;

@end

@implementation ViewController

#pragma mark Init

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    return self;
}

#pragma mark Light Show GUI

//Launch Light Show W/ GUI
- (IBAction)launchLightShowGUI:(id)sender {
    UIViewController *initialController = [SwiftHelper getInitialViewController];
    initialController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:initialController animated:YES completion:NULL];
}

# pragma mark CUEBroadcastClient

- (IBAction)startCueBleScanning:(id)sender {
    
    // This code should be called at the appropriate time, at it may trigger a Bluetooth Permission Request from the user
    
    self.broadcastClient = [[CUEBroadcastClient alloc] initWithServiceUuid:[[CUEClientConfig sharedInstance] cueBroadcastServiceUuid]];
    self.broadcastClient.delegate = self;
    [self.broadcastClient start];
}

- (void)didDetectTrigger:(nonnull NSString *) trigger {
    [[CueNotificationsHelper sharedInstance] handleDetectedBleTrigger:trigger];
}

@end
