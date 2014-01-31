//
//  AppDelegate.m
//  JumpTest
//
//  Created by Cody Mace on 1/7/14.
//  Copyright (c) 2014 Cody Mace. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    SKScene *scene = [MyScene sceneWithSize: CGSizeMake(2048, 1536)];
    [self.window setFrame:[[NSScreen mainScreen] visibleFrame] display:YES];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
