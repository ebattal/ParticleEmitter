//
//  ParticleEmitter.h
//  ParticleEmitter
//
//  Created by EBattal on 8/13/10.
//  This file is originated from work of Jeff LaMarche

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import "OpenGLTexture3D.h"

// Generates float from -1.0 to 1.0 for calculating random variance
#define Particle3DRandom() (((float)(arc4random() % 100) / 50.0) - 1.0)

//particle type
typedef struct Particle {
	Vertex3D			position;
	Vertex3D			lastPosition;
	Vector3D			direction;
	
	NSTimeInterval		timeToDie;
	NSTimeInterval		timeWasBorn;
	
	Color3D				color;
	Color3D				colorAtEnd;
	Color3D				colorAtBeginning;
	
	GLfloat				particleSize;
	struct Particle		*next;
	struct Particle		*prev;
} Particle3D;

// This will be used to indicated different ways of drawing particles
typedef enum  {
	ParticleEmitter3DDrawPoints,
	ParticleEmitter3DDrawLines,
	ParticleEmitter3DDrawDiamonds,
	ParticleEmitter3DDrawSquares,
	ParticleEmitter3DDrawCircles,
	ParticleEmitter3DDrawTriangles,
	ParticleEmitter3DDrawTextureMap,
	ParticleEmitterDrawModeCount
} ParticleEmitter3DDrawMode;


/*for testing purposes*/

typedef struct dllist {
	int number;
	struct dllist *next;
	struct dllist *prev;
} testStruct;

void test();

void cleanDeadParticles();
void moveAndCreateParticles();
////***************/////

@interface ParticleEmitter3D : NSObject {
	NSString					*name;
	Particle3D					*particles;

	Vertex3D					startPosition;
	Vertex3D					startPositionVariance;

	GLfloat						azimuth;
	GLfloat						azimuthVariance;
	GLfloat						pitch;
	GLfloat						pitchVariance;
	
	GLfloat						particleSpeed;
	GLfloat						particleSpeedVariance;
	
	
/* I don't know what these are for	
	GLuint						lifetimeParticlesCount;
	GLuint						currentParticleCount;
*/
	
	GLuint						particlesPerSecond;
	GLuint						particlesPerSecondVariance;
	
	NSTimeInterval				particleLifespan;
	NSTimeInterval				particleLifespanVariance;
	
	Color3D						startColor;
	Color3D						startColorVariance;
	Color3D						finishColor;
	Color3D						finishColorVariance;
	
	Vector3D					force;
	Vector3D					forceVariance;
	
	ParticleEmitter3DDrawMode	mode;
	
	GLfloat						particleSize;
	GLfloat						particleSizeVariance;
	
	BOOL						isEmitting;

//Not Sure whether this is needed
	OpenGLTexture3D				*texture;
	
	
	//private variables
	Particle3D					*tail;
	NSTimeInterval				lastMovementTime;
	float						newParticleCount;
	NSInteger					particleCount;
	BOOL						noParticles;
	
@private
	int							slideDistance;
}

@property (nonatomic, retain) NSString *		name;
@property Particle3D							*particles;
@property Particle3D							*tail;
@property Vertex3D								startPosition;
@property Vertex3D								startPositionVariance;

@property GLfloat								azimuth;
@property GLfloat								azimuthVariance;
@property GLfloat								pitch;
@property GLfloat								pitchVariance;

@property GLfloat								particleSpeed;
@property GLfloat								particleSpeedVariance;

/* LOOK ABOVE FOR EXPLANATION
@property GLuint								lifetimeParticlesCount;
@property GLuint								currentParticleCount;
*/

@property GLuint								particlesPerSecond;
@property GLuint								particlesPerSecondVariance;
@property NSTimeInterval						particleLifespan;
@property NSTimeInterval						particleLifespanVariance;
@property Color3D								startColor;
@property Color3D								startColorVariance;
@property Color3D								finishColor;
@property Color3D								finishColorVariance;
@property Vector3D								force;
@property Vector3D								forceVariance;
@property ParticleEmitter3DDrawMode				mode;
@property GLfloat								particleSize;
@property GLfloat								particleSizeVariance;
@property BOOL									isEmitting;
@property (retain) OpenGLTexture3D				*texture;
@property float									newParticleCount;
@property NSTimeInterval						lastMovementTime;		
@property NSInteger								particleCount;

//Not Sure whether this is needed
//@property (nonatomic, retain) OpenGLTexture3D	*texture;


- (id)initWithName:(NSString *)inName 
	 startPosition:(Vertex3D)inStartPosition
startPositionVariance:(Vertex3D)inStartPositionVariance
		   azimuth:(GLfloat)inAzimuth
   azimuthVariance:(GLfloat)inAzimuthVariance
		   pitch:(GLfloat)inPitch
	 pitchVariance:(GLfloat)inPitchVariance
	 particleSpeed:(GLfloat)inParticleSpeed
particleSpeedVariance:(GLfloat)inParticleSpeedVariance
particlesPerSecond:(GLuint)inParticlesPerSecond
particlesPerSecondVariance:(GLuint)inParticlesPerSecondVariance
  particleLifespan:(NSTimeInterval)inParticleLifespan
particleLifespanVariance:(NSTimeInterval)inParticleLifespanVariance
		startColor:(Color3D)inStartColor
startColorVariance:(Color3D)inStartColorVariance
	   finishColor:(Color3D)inFinishColor
finishColorVariance:(Color3D)inFinishColorVariance
			 force:(Vector3D)ingravity
	 forceVariance:(Vector3D)inforceVariance
			  mode:(ParticleEmitter3DDrawMode)inMode
	  particleSize:(GLfloat)inParticleSize
particleSizeVariance:(GLfloat)inParticleSizeVariance
		   texture:(OpenGLTexture3D *)inTexture;

-(void) stopEmitter;
-(void) startEmitter;
-(void) processParticles;
-(int) particleCount;
@end
