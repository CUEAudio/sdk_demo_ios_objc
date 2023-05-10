//
//  ViewController.m
//  CUEControllerDemo
//
//  Created by Jameson Rader on 5/23/18.
//  Copyright © 2018 CUE Audio, LLC. All rights reserved.
//

#import "ViewController.h"
#import <CUEControllerDemo-Swift.h>

@interface ViewController ()

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

@end
