//
//  OpenGLesAppDelegate.h
//  ParticleEmitter
//
//  Created by EBattal on 8/9/10.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"

@interface OpenGLesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end

