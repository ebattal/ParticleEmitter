//
//  ParticleEmitter3D-Factories.m
//  ParticleEmitter
//
//  Created by Jeff LaMarche on 1/1/09.
//	Modified by EBattal on 10/8/10
//

#import "ParticleEmitter3DDatabase.h"
#import "OpenGLTexture3D.h"

@implementation ParticleEmitter3DDatabase
#pragma mark -
#pragma mark Factory Methods

+ (ParticleEmitter3D *)balloonFly 
{
	//Load Texture (Particle)
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	
	//Balloon Emitter
	return [[ParticleEmitter3D alloc] initWithName:@"Balloon Emitter" 
									 startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							 startPositionVariance:Vertex3DMake(0.1, 0.1, 0.0)
										   azimuth:0
								   azimuthVariance:60
											 pitch:0
									 pitchVariance:60
									 particleSpeed:0.5
							 particleSpeedVariance:0.2
								particlesPerSecond:15
						particlesPerSecondVariance:3 
								  particleLifespan:9.0
						  particleLifespanVariance:2.0
										startColor:Color3DMake(0.5, 0.5, 0.5, 1) 
								startColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
									   finishColor:Color3DMake(0.5, 0.5, 0.5, 1)
							   finishColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
											 force:Vector3DMake(0.0, 0.0, 0.5)
									 forceVariance:Vector3DMake(0.5, 1.0, 0.5)
											  mode:ParticleEmitter3DDrawTextureMap
									  particleSize:30
							  particleSizeVariance:8
										   texture:texture] ;
	
	[texture release];
}

+ (ParticleEmitter3D *)fountainEmitter
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	
	return [[[ParticleEmitter3D alloc] initWithName:@"Fountain Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:25.0
											  pitch:90
									  pitchVariance:25.0 
									  particleSpeed:2.0
							  particleSpeedVariance:0.0
								 particlesPerSecond:400
						 particlesPerSecondVariance:50 
								   particleLifespan:15.0 
						   particleLifespanVariance:1.0 
										 startColor:Color3DMake(0.0, 0.0, 0.95, 1.0) 
								 startColorVariance:Color3DMake(0.0, 0.0, 0.1, 0.0) 
										finishColor:Color3DMake(0.7, 0.7, 1.0, 1.0)
								finishColorVariance:Color3DMake(0.0, 0.0, 0.0, 0.0) 
											  force:Vector3DMake(0.0, -1.25, .0)
									  forceVariance:Vector3DMake(0.0, 0.0, 0.0)
											   mode:ParticleEmitter3DDrawTextureMap
									   particleSize:3
							   particleSizeVariance:3
											texture:texture] autorelease];
	[texture release];
}

+ (ParticleEmitter3D *)neonBlueExplosionEmitter
{
	return [[[ParticleEmitter3D alloc] initWithName:@"Neon Blue Explosion Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0)
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:180.0
											  pitch:90
									  pitchVariance:180.0 
									  particleSpeed:1.0
							  particleSpeedVariance:0.2
								 particlesPerSecond:600 
						 particlesPerSecondVariance:90 
								   particleLifespan:1.0
						   particleLifespanVariance:.25 
										 startColor:Color3DMake(0.3, 0.3, 0.5, 1.0) 
								 startColorVariance:Color3DMake(0.5, 0.5, 0.1, 0.0) 
										finishColor:Color3DMake(0.95, 0.0, 1.0, 1.0)
								finishColorVariance:Color3DMake(0.1, 0.1, 0.1, 0.0) 
											  force:Vector3DMake(0.0, 0.0, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.5, 0.0)
											   mode:ParticleEmitter3DDrawPoints
									   particleSize:1.0
							   particleSizeVariance:0.0
											texture:nil] autorelease];
}
+ (ParticleEmitter3D *)explosionEmitter
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	return [[[ParticleEmitter3D alloc] initWithName:@"Explosion Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:180.0
											  pitch:90
									  pitchVariance:180.0 
									  particleSpeed:3.0
							  particleSpeedVariance:0.2
								 particlesPerSecond:600 
						 particlesPerSecondVariance:100
								   particleLifespan:3.0
						   particleLifespanVariance:.25 
										 startColor:Color3DMake(.95, 0.2, 0.2, 1.0) 
								 startColorVariance:Color3DMake(0.1, 0.2, 0.2, 0.0) 
										finishColor:Color3DMake(0.0, 0.0, 0.0, 0.0)
								finishColorVariance:Color3DMake(0.0, 0.0, 0.0, 0.0) 
											  force:Vector3DMake(0.0, 0.0, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.5, 0.0)
											   mode:ParticleEmitter3DDrawTextureMap
									   particleSize:3.0
							   particleSizeVariance:0.0
											texture:texture] autorelease];
	[texture release];
}
+ (ParticleEmitter3D *)torchEmitter
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	return [[[ParticleEmitter3D alloc] initWithName:@"Torch Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:15.0
											  pitch:90
									  pitchVariance:15.0 
									  particleSpeed:0.2
							  particleSpeedVariance:0.1
								 particlesPerSecond:500 
						 particlesPerSecondVariance:50 
								   particleLifespan:3.25
						   particleLifespanVariance:.50 
										 startColor:Color3DMake(1.0, 0.4, 0.2, 1.0) 
								 startColorVariance:Color3DMake(0.0, 0.1, 0.1, 0.0) 
										finishColor:Color3DMake(0.0, 0.0, 0.0, 1.0)
								finishColorVariance:Color3DMake(0.09, 0.1, 0.1, 0.0) 
											  force:Vector3DMake(0.0, 0.0, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.1, 0.0)
											   mode:ParticleEmitter3DDrawTextureMap
									   particleSize:5.0
							   particleSizeVariance:5.0
											texture:texture] autorelease];
	[texture release];
}
+ (ParticleEmitter3D *)confettiParticleEmitter
{
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	return [[[ParticleEmitter3D alloc] initWithName:@"Confetti Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:20.0
											  pitch:90
									  pitchVariance:20.0 
									  particleSpeed:3.0
							  particleSpeedVariance:0.0
								 particlesPerSecond:600 
						 particlesPerSecondVariance:90 
								   particleLifespan:9.0
						   particleLifespanVariance:2.0 
										 startColor:Color3DMake(0.5, 0.5, 0.5, 1.0) 
								 startColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
										finishColor:Color3DMake(0.5, 0.5, 0.5, 1.0)
								finishColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
											  force:Vector3DMake(0.0, -2.0, 0.0)
									  forceVariance:Vector3DMake(0.0, 2.0, 0.0)
											   mode:ParticleEmitter3DDrawTextureMap
									   particleSize:4
							   particleSizeVariance:2.0
											texture:texture] autorelease];
	[texture release];
}
+ (ParticleEmitter3D *)squareEmitter
{
	return [[[ParticleEmitter3D alloc] initWithName:@"Square Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:45
											  pitch:90
									  pitchVariance:45
									  particleSpeed:1.0
							  particleSpeedVariance:0.2
								 particlesPerSecond:600 
						 particlesPerSecondVariance:25 
								   particleLifespan:5.0
						   particleLifespanVariance:1.0 
										 startColor:Color3DMake(0.5, 0.5, 0.5, 1.0) 
								 startColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
										finishColor:Color3DMake(0.5, 0.5, 0.5, 1.0)
								finishColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
											  force:Vector3DMake(0.0, -.5, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.5, 0.0)
											   mode:ParticleEmitter3DDrawSquares
									   particleSize:1.0
							   particleSizeVariance:0.0
											texture: nil] autorelease];
}
+ (ParticleEmitter3D *)circleEmitter
{
	return [[[ParticleEmitter3D alloc] initWithName:@"Circle Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:35.0
											  pitch:90
									  pitchVariance:35.0 
									  particleSpeed:2.0
							  particleSpeedVariance:0.2
								 particlesPerSecond:600 
						 particlesPerSecondVariance:25 
								   particleLifespan:5.0
						   particleLifespanVariance:1.0 
										 startColor:Color3DMake(0.5, 0.5, 0.5, 1.0) 
								 startColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
										finishColor:Color3DMake(0.5, 0.5, 0.5, 1.0)
								finishColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
											  force:Vector3DMake(0.0, -.5, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.5, 0.0)
											   mode:ParticleEmitter3DDrawCircles
									   particleSize:1.0
							   particleSizeVariance:0.0
											texture: nil] autorelease];
}
+ (ParticleEmitter3D *)triangleEmitter
{
	return [[[ParticleEmitter3D alloc] initWithName:@"Triangle Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:30.0
											  pitch:90
									  pitchVariance:30.0 
									  particleSpeed:1.0
							  particleSpeedVariance:0.2
								 particlesPerSecond:600 
						 particlesPerSecondVariance:25 
								   particleLifespan:5.0
						   particleLifespanVariance:1.0 
										 startColor:Color3DMake(0.5, 0.5, 0.5, 1.0) 
								 startColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
										finishColor:Color3DMake(0.5, 0.5, 0.5, 1.0)
								finishColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
											  force:Vector3DMake(0.5, -.5, 0.0)
									  forceVariance:Vector3DMake(0.3, 0.5, 0.0)
											   mode:ParticleEmitter3DDrawTriangles
									   particleSize:1.0
							   particleSizeVariance:0.0
											texture: nil] autorelease];
}
+ (ParticleEmitter3D *)diamondEmitter
{
	return [[[ParticleEmitter3D alloc] initWithName:@"Diamond Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0)
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:45.0
											  pitch:90
									  pitchVariance:45.0 
									  particleSpeed:1.0
							  particleSpeedVariance:0.2
								 particlesPerSecond:600 
						 particlesPerSecondVariance:25 
								   particleLifespan:5.0
						   particleLifespanVariance:1.0 
										 startColor:Color3DMake(0.5, 0.5, 0.5, 1.0) 
								 startColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
										finishColor:Color3DMake(0.5, 0.5, 0.5, 1.0)
								finishColorVariance:Color3DMake(1.0, 1.0, 1.0, 0.0) 
											  force:Vector3DMake(0.0, -.5, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.5, 0.0)
											   mode:ParticleEmitter3DDrawDiamonds
									   particleSize:1.0
							   particleSizeVariance:0.0
											texture: nil] autorelease];
}
+ (ParticleEmitter3D *)fireEmitter
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	return [[[ParticleEmitter3D alloc] initWithName:@"Fire Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:30.0
											  pitch:90
									  pitchVariance:45.0 
									  particleSpeed:0.5
							  particleSpeedVariance:0.1
								 particlesPerSecond:150.0
						 particlesPerSecondVariance:25.0 
								   particleLifespan:3.0
						   particleLifespanVariance:1.0 
										 startColor:Color3DMake(0.9, 0.4, 0.0, 1.0) 
								 startColorVariance:Color3DMake(0.2, 0.2, 0.0, 0.0) 
										finishColor:Color3DMake(0.0, 0.0, 0.0, 0.0)
								finishColorVariance:Color3DMake(0.0, 0.0, 0.0, 0.0) 
											  force:Vector3DMake(0.0, 0.0, 0.0)
									  forceVariance:Vector3DMake(0.1, 0.2, 0.2)
											   mode:ParticleEmitter3DDrawTextureMap
									   particleSize:15.0
							   particleSizeVariance:5.0
											texture: texture] autorelease];
	[texture release];
}
+ (ParticleEmitter3D *)whiteBurst
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	return [[[ParticleEmitter3D alloc] initWithName:@"Green Fog Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0) 
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:360.0
											  pitch:90
									  pitchVariance:360 
									  particleSpeed:2
							  particleSpeedVariance:1
								 particlesPerSecond:600
						 particlesPerSecondVariance:20 
								   particleLifespan:4
						   particleLifespanVariance:1.0 
										 startColor:Color3DMake(0.95, 0.95, 0.95, 1) 
								 startColorVariance:Color3DMake(0.1, 0.1, 0.1, 0.5) 
										finishColor:Color3DMake(0.75, 0.75, 0.75, 1)
								finishColorVariance:Color3DMake(0.1, 0.1, 0.1, 0.0) 
											  force:Vector3DMake(0.0, 0.0, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.0, 0.0)
											   mode:ParticleEmitter3DDrawTextureMap
									   particleSize:3.0
							   particleSizeVariance:3.0
											texture:texture] autorelease];
	[texture release];
}
+ (ParticleEmitter3D *)pixieDust
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"png"];
	OpenGLTexture3D *texture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512]; 
	return [[[ParticleEmitter3D alloc] initWithName:@"Green Fog Emitter" 
									  startPosition:Vertex3DMake(0.0, 0.0, -2.0)
							  startPositionVariance:Vertex3DMake(0.0, 0.0, 0.0)
											azimuth:0
									azimuthVariance:360.0
											  pitch:90
									  pitchVariance:360 
									  particleSpeed:0.1
							  particleSpeedVariance:0.05
								 particlesPerSecond:100 
						 particlesPerSecondVariance:20 
								   particleLifespan:10.0
						   particleLifespanVariance:2.0 
										 startColor:Color3DMake(0.0, 0.95, 0.0, 1) 
								 startColorVariance:Color3DMake(0.0, 0.1, 0.0, 0.5) 
										finishColor:Color3DMake(0.00, 0.95, 1.0, 1)
								finishColorVariance:Color3DMake(0.0, 0.1, 0.0, 0.0) 
											  force:Vector3DMake(0.0, 0.0, 0.0)
									  forceVariance:Vector3DMake(0.0, 0.5, 0.0)
											   mode:ParticleEmitter3DDrawTextureMap
									   particleSize:10.0
							   particleSizeVariance:3.0
											texture:texture] autorelease];
	[texture release];
}

@end
