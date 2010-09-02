//
//  OpenGLesAppDelegate.m
//  ParticleEmitter
//
//  Created by EBattal on 8/9/10.
//

#import "OpenGLesAppDelegate.h"

@implementation OpenGLesAppDelegate

@synthesize window;
@synthesize glView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)dealloc
{
    [window release];
    [glView release];
    [super dealloc];
}

@end
