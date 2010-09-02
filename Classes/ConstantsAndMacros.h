//
//	ConstantsAndMacros.h
//  ParticleEmitter
//
//  Created by Jeff LaMarche on 12/30/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

// How many times a second to refresh the screen
#if TARGET_OS_IPHONE
#define kRenderingFrequency 15.0
#elif TARGET_IPHONE_SIMULATOR
#define kRenderingFrequency 30.0
#endif
// For setting up perspective, define near, far, and angle of view
#define kZNear			0.01
#define kZFar			1000.0
#define kFieldOfView	45.0

// Macros
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)