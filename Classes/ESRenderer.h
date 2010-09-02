//
//  ESRenderer.h
//  ParticleEmitter
//
//  Created by EBattal on 8/9/10.

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol ESRenderer <NSObject>

- (void)render:(UIView*)view;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
