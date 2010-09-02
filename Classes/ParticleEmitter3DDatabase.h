//
//  ParticleEmitter3D-Factories.h
//  ParticleEmitter
//
//  Created by Jeff LaMarche on 1/1/09.
//	Modified by EBattal on 10/8/10

#import <Foundation/Foundation.h>
#import "ParticleEmitter3D.h"

@interface ParticleEmitter3DDatabase:NSObject
+ (ParticleEmitter3D *)balloonFly;
+ (ParticleEmitter3D *)fountainEmitter;
+ (ParticleEmitter3D *)neonBlueExplosionEmitter;
+ (ParticleEmitter3D *)explosionEmitter;
+ (ParticleEmitter3D *)confettiParticleEmitter;
+ (ParticleEmitter3D *)torchEmitter;
+ (ParticleEmitter3D *)squareEmitter;
+ (ParticleEmitter3D *)triangleEmitter;
+ (ParticleEmitter3D *)fireEmitter;
+ (ParticleEmitter3D *)diamondEmitter;
+ (ParticleEmitter3D *)circleEmitter;
+ (ParticleEmitter3D *)pixieDust;
+ (ParticleEmitter3D *)whiteBurst;
@end
