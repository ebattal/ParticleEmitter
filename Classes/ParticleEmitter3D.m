//
//  ParticleEmitter.m
//  ParticleEmitter
//
//  Created by EBattal on 8/13/10.
//  This file is originated from work of Jeff LaMarche

//	The particle emitter originally written by LaMarche is 
//	seperated to two parts : The Core and The Drawer Part.
//  This is the core part which handles the calculations 
//	about particles

// Some Modifications:

// Beginning of both azimuth and pitch variances are added
// and their functions are implemented - Ebattal
// StartPoint and StartPointVariance variables are added and their 
// function implemented	- Ebattal
// Memory management of the particles are fixed : Every particle
// gets freed when it is lifetime is over. - Ebattal

#import "ParticleEmitter3D.h"


@implementation ParticleEmitter3D
@synthesize name;
@synthesize particles;

@synthesize startPosition;
@synthesize startPositionVariance;

@synthesize azimuth;
@synthesize azimuthVariance;
@synthesize pitch;
@synthesize pitchVariance;
@synthesize particleSpeed;
@synthesize particleSpeedVariance;
@synthesize forceVariance;
@synthesize particlesPerSecond;
@synthesize particlesPerSecondVariance;
@synthesize particleLifespan;
@synthesize particleLifespanVariance;
@synthesize startColor;
@synthesize startColorVariance;
@synthesize finishColor;
@synthesize finishColorVariance;
@synthesize force;
@synthesize	mode;
@synthesize particleSize;
@synthesize particleSizeVariance;
@synthesize isEmitting;
@synthesize newParticleCount;
@synthesize lastMovementTime;
@synthesize	texture;
@synthesize tail;
@synthesize	particleCount;
void Particle3DDebugPrint(Particle3D *list)
{
	Particle3D *oneParticle = list;
	NSLog(@"=================================================================================");
	while (oneParticle)
	{	
		NSLog(@"particle: %d (next=%d, prev=%d)", oneParticle, oneParticle->next, oneParticle->prev);
		
		/*
		NSLog(@"==========================Particle Info==========================");
		
		NSLog(@"Position:			%f, %f, %f",oneParticle->position.x,oneParticle->position.y,oneParticle->position.z);
		NSLog(@"Last Position:		%f, %f, %f",oneParticle->lastPosition.x,oneParticle->lastPosition.y,oneParticle->lastPosition.z);
		NSLog(@"Direction:			%f, %f, %f",oneParticle->direction.x,oneParticle->direction.y,oneParticle->direction.z);
		NSLog(@"TimeToDie:			%f",oneParticle->timeToDie);
		NSLog(@"TimeWasBorn:		%f",oneParticle->timeWasBorn);
		NSLog(@"Color:				%f, %f, %f, %f",oneParticle->color.red,oneParticle->color.green,oneParticle->color.blue,oneParticle->color.alpha);
		NSLog(@"ColorAtStart:		%f, %f, %f, %f",oneParticle->colorAtBeginning.red,oneParticle->colorAtBeginning.green,oneParticle->colorAtBeginning.blue,oneParticle->colorAtBeginning.alpha);
		NSLog(@"ColorAtEnd:			%f, %f, %f, %f",oneParticle->colorAtEnd.red,oneParticle->colorAtEnd.green,oneParticle->colorAtEnd.blue,oneParticle->colorAtEnd.alpha);
		NSLog(@"Size:				%f",oneParticle->particleSize);
		NSLog(@"=================================================================");
		
		*/
		oneParticle = oneParticle->next;

	}
	NSLog(@"=================================================================================");
}

Particle3D* Particle3DMake(Vertex3D position, Vector3D direction,NSTimeInterval timeWasBorn, NSTimeInterval timeToDie, Color3D colorAtEnd, Color3D colorAtBeginning, GLfloat inParticleSize)
{
	Particle3D *ret = (Particle3D *) malloc(sizeof(Particle3D));;
	ret->position = position;
	ret->lastPosition = position;
	ret->direction = direction;
	ret->timeToDie = timeToDie;
	ret->colorAtEnd = colorAtEnd;
	ret->colorAtBeginning = colorAtBeginning;
	ret->color = colorAtBeginning;
	ret->particleSize = inParticleSize;
	ret->timeWasBorn = timeWasBorn;
	ret->prev = NULL;
	ret->next = NULL;
	
	return ret;
}

void addParticleToList(ParticleEmitter3D *emitter, Particle3D *particle) {
	emitter.tail->next=particle;
	particle->prev=emitter.tail;
	emitter.tail=emitter.tail->next;
	emitter.particleCount++;
}

void createParticles ( ParticleEmitter3D *emitter, NSTimeInterval timeElapsed ) {

	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];

	//Calculate new particle count
	emitter.newParticleCount += (emitter.particlesPerSecond + emitter.particlesPerSecondVariance * Particle3DRandom()) * timeElapsed;

	int intParticleCount = (int) emitter.newParticleCount;
//	NSLog(@"EmitterParticleCount: %f",emitter.newParticleCount);
//	NSLog(@"Create Particles");

	//Create New Particles 
	for (int i=0; i<intParticleCount; i++) 
	{
		NSTimeInterval howLongToLive = emitter.particleLifespan + (Particle3DRandom() * emitter.particleLifespanVariance);
		GLfloat tmpAzimuth = emitter.azimuth + emitter.azimuthVariance * Particle3DRandom();
		GLfloat tmpPitch =  emitter.pitch + (emitter.pitchVariance * Particle3DRandom());
		Vector3D direction;
		Vector3DRotateToDirection(tmpPitch, tmpAzimuth, &direction);

		GLfloat positionX = emitter.startPosition.x + emitter.startPositionVariance.x * Particle3DRandom();
		GLfloat positionY = emitter.startPosition.y + emitter.startPositionVariance.y * Particle3DRandom();
		GLfloat positionZ = emitter.startPosition.z + emitter.startPositionVariance.z * Particle3DRandom();
	
		Vertex3D position = Vertex3DMake(positionX,positionY,positionZ);
		
		GLfloat speed = emitter.particleSpeed + (emitter.particleSpeedVariance * Particle3DRandom());
		direction.x *= (speed);
		direction.y *= (speed);
		direction.z *= (speed);
		
		Color3D start = emitter.startColor;
		start.red *= emitter.startColor.red + (emitter.startColorVariance.red * Particle3DRandom());
		start.blue *= emitter.startColor.blue + (emitter.startColorVariance.blue * Particle3DRandom());
		start.green *= emitter.startColor.green + (emitter.startColorVariance.green * Particle3DRandom());
		
		Color3D finish = emitter.finishColor;
		finish.red *= emitter.finishColor.red + (emitter.finishColorVariance.red * Particle3DRandom());
		finish.blue *= emitter.finishColor.blue + (emitter.finishColorVariance.blue * Particle3DRandom());
		finish.green *= emitter.finishColor.green + (emitter.finishColorVariance.green * Particle3DRandom());
		
		GLfloat size = emitter.particleSize + (emitter.particleSizeVariance * Particle3DRandom());
		Particle3D *createdParticle = Particle3DMake(position,direction,now, now + howLongToLive, finish, start, size);
		
		if (emitter.particles == NULL)	//If there is no particle in the list, add the first one
		{
			emitter.particles = createdParticle;
			emitter.tail = emitter.particles;
			emitter.particleCount = 1;
		}
		else	//If there are already some particles in the list, append this to the list
		{
			addParticleToList(emitter, createdParticle);
		}
	}

	emitter.newParticleCount -= (float) intParticleCount;

}

void moveParticles ( ParticleEmitter3D *emitter, NSTimeInterval timeElapsed ) {
	
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];

	Particle3D *present = emitter.particles;
//	NSLog(@"Move Particles");

	while(present) {

		//Set last position
		present->lastPosition = present->position;
		
		//Update present position according to elapsed time 
		present->position.x += present->direction.x * timeElapsed;
		present->position.y += present->direction.y * timeElapsed;
		present->position.z += present->direction.z * timeElapsed;
		
		//Apply variance of the force.
		present->direction.x += (emitter.force.x + (emitter.forceVariance.x * Particle3DRandom())) * timeElapsed;
		present->direction.y += (emitter.force.y + (emitter.forceVariance.y * Particle3DRandom())) * timeElapsed;
		present->direction.z += (emitter.force.z + (emitter.forceVariance.z * Particle3DRandom())) * timeElapsed;
		
		GLfloat percentThroughLife = (now < present->timeWasBorn) ? 0.0 : (now - present->timeWasBorn) / (present->timeToDie - present->timeWasBorn);
		if (percentThroughLife > 1.0)
			percentThroughLife = 1.0;
		
		present->color = Color3DInterpolate(present->colorAtBeginning, present->colorAtEnd, percentThroughLife);

		present = present->next;
	}
}

void cleanDeadParticles(ParticleEmitter3D *emitter) {
	Particle3D *present = emitter.particles;
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
//	NSLog(@"Clean Particles");
	while(present) 
	{
		if((present->timeToDie - now) > emitter.particleLifespanVariance) {
			break;
		}
		
		if(now > (present->timeToDie)) {
			//If there is no particle except itself
			if(present->prev == NULL && present->next == NULL)
			{
				// NSLog(@"Empty Head");
				free(present);
				present=NULL;
				emitter.particles=NULL;
				emitter.tail=NULL;
			}
			else if(present->prev==NULL)	//if it is at the beginning of the list
			{
				// NSLog(@"Head");
				emitter.particles=present->next;
				emitter.particles->prev=NULL;
				free(present);
				present=emitter.particles;
			}
			else if(present->next==NULL)		//if it is at the end of the list
			{
				// NSLog(@"Tail");
				emitter.tail=present->prev;
				present->prev->next=NULL;
				free(present);
				present=NULL;
			} else {						//if it in the middle of the list
				// NSLog(@"Middle");
				Particle3D *tmp = present;
		
				// NSLog(@"Address : %d",tmp);
				present->prev->next=tmp->next;

				present->next->prev=tmp->prev;
				
				//go to the next element
				present=present->next;

				//free the present element
				free(tmp);
				tmp=NULL;
			}
			emitter.particleCount--;
			// NSLog(@"Cleaned");
		} else {
			present=present->next;
		}
	}

}


-(id)initWithName:(NSString *)inName 
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
		  texture:(OpenGLTexture3D *)inTexture
{
	if ((self = [super init]))
	{
		self.name = inName;
		self.startPosition = inStartPosition;
		self.startPositionVariance = inStartPositionVariance;
		self.azimuth = inAzimuth;
		self.azimuthVariance = inAzimuthVariance;
		self.pitch = inPitch;
		self.pitchVariance = inPitchVariance;
		self.particleSpeed = inParticleSpeed;
		self.particleSpeedVariance = inParticleSpeedVariance;
		self.particlesPerSecond = inParticlesPerSecond;
		self.particlesPerSecondVariance = inParticlesPerSecondVariance;
		self.particleLifespan = inParticleLifespan;
		self.particleLifespanVariance = inParticleLifespanVariance;
		self.startColor = inStartColor;
		self.startColorVariance = inStartColorVariance;
		self.finishColor = inFinishColor;
		self.finishColorVariance = inFinishColorVariance;
		self.force = ingravity;
		self.forceVariance = inforceVariance;
		self.mode = inMode;
		self.particleSize = inParticleSize;
		self.particleSizeVariance = inParticleSize;
		self.isEmitting = NO;
		self.texture = inTexture;
		self.particles=NULL;
		self.particleCount = 0;
		self.tail=NULL;
		lastMovementTime = [NSDate timeIntervalSinceReferenceDate];
	}
	return self;
}

-(void) startEmitter{
	NSLog(@"Start Emitter");
	self.isEmitting=YES;
}

-(void) stopEmitter {
	NSLog(@"Stop Emitter");
	self.isEmitting = NO;
}

-(void) processParticles{
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	NSTimeInterval elapsedTime = [NSDate timeIntervalSinceReferenceDate] - self.lastMovementTime;	

	//Delete all dead particles
	cleanDeadParticles(self);
	
	//If emission is on, create new particles
	if(self.isEmitting) {
		createParticles(self, elapsedTime);
	}
	
	//Particle3DDebugPrint(self.particles);

	//Move the present particles
	moveParticles(self, elapsedTime);
	self.lastMovementTime = now;

//	NSLog(@"Particle Count: %d",[self particleCount]);

}

void test(ParticleEmitter3D *emitter) {	
	static int test=0;
	int debug=2;
	if(debug==1) 
	{
		testStruct *main;
		testStruct *present;
		main = (testStruct *)malloc(sizeof(testStruct));
		main->number=0;
		main->prev=NULL;
		main->next=NULL;
		
		testStruct *tmpStruct = malloc(sizeof(testStruct));
		tmpStruct->number=1;
		tmpStruct->next=NULL;
		tmpStruct->prev=NULL;
		
		testStruct *tmpStruct2 = malloc(sizeof(testStruct));
		tmpStruct2->number=2;
		tmpStruct2->next=NULL;
		tmpStruct2->prev=NULL;
		
		present=main;
		present->next=tmpStruct;
		present->next->prev=present;
		
		present=present->next;
		present->next=tmpStruct2;
		present->next->prev=present;
		

		testStruct *oneParticle = main;
		
		NSLog(@"=================================================================================");
		while (oneParticle)
		{	
			NSLog(@"particle: %d (next=%d, prev=%d)", oneParticle, oneParticle->next, oneParticle->prev);
			oneParticle = oneParticle->next;
		}
		NSLog(@"=================================================================================");
		
		//remove from middle
		testStruct *tmp = present;
		NSLog(@"Address : %d",tmp);
		present->prev->next=tmp->next;
		present->next->prev=tmp->prev;
		//go to the next element
		present=present->next;
		
		//free the present element
		free(tmp);
		oneParticle = main;
		NSLog(@"=================================================================================");
		while (oneParticle)
		{	
			NSLog(@"particle: %d (next=%d, prev=%d)", oneParticle, oneParticle->next, oneParticle->prev);
			oneParticle = oneParticle->next;
		}
		NSLog(@"=================================================================================");
		
		//remove remainings;
		free(main->next);
		free(main);
	}
	else if (debug ==2) 
	{
		test++;
	//	NSLog(@"TestFunction()");
		[emitter processParticles];
		if(test == 1000) {
			[emitter stopEmitter];
		}

	}
	
}
@end

