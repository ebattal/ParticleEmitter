//
//  ES1Renderer.m
//  ParticleEmitter
//
//  Created by EBattal on 8/9/10.
//  This file is originated from work of Jeff LaMarche

//	The particle emitter originally written by LaMarche is 
//	seperated to two parts : The Core and The Drawer Part.
//  This is the Drawer part which handles the OpenGL ES  
//	drawing operations and its memory management

#import "ES1Renderer.h"
#import "ParticleEmitter3DDatabase.h"

@implementation ES1Renderer
@synthesize particleEmitters;
//@synthesize vertices,vertexColors,textureCoords,normals;
// Create an OpenGL ES 1.1 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
        if (!context || ![EAGLContext setCurrentContext:context])
        {
            [self release];
            return nil;
        }
		
        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
    }
	
    return self;
}

- (NSInteger)theoreticalMaxParticles:(ParticleEmitter3D *) emitter 
{
	return (emitter.particlesPerSecond + (emitter.particlesPerSecondVariance/2+1)) * (emitter.particleLifespan + (emitter.particleLifespanVariance/2+1));
}

//Allocate arrays for drawing elements
- (void)allocArrays
{
	int emitterCount = [self.particleEmitters count];
	vertices = malloc(sizeof(GLfloat *) * emitterCount);
	vertexColors = malloc(sizeof(GLfloat *) * emitterCount);
	
	textureCoords = malloc(sizeof(GLfloat *) * emitterCount);
	normals = malloc(sizeof(GLfloat *) * emitterCount);
	
	for(int i=0; i < emitterCount; i++) {

		int particleCount = [[particleEmitters objectAtIndex:i] particleCount];
//		int particleCount = [self theoreticalMaxParticles:[particleEmitters objectAtIndex:i]];
		switch ([[particleEmitters objectAtIndex:i] mode]) 
		{
			case ParticleEmitter3DDrawPoints:
			{
				vertices[i] = malloc(sizeof(GLfloat) * 3 * particleCount);
				vertexColors[i] = malloc(sizeof(GLfloat) * 4 * particleCount);
				textureCoords[i] = NULL;
				normals[i] = NULL;
				break;
			}
			case ParticleEmitter3DDrawSquares:
			{
				vertices[i] = malloc(sizeof(GLfloat) * 3 * particleCount* 4);
				vertexColors[i] = malloc(sizeof(GLfloat) * 4 * particleCount * 4);
				textureCoords[i] = NULL;
				normals[i] = NULL;
				break;
			}
			case ParticleEmitter3DDrawTextureMap:
			{			
				vertices[i] = malloc(sizeof(GLfloat) * 3 * particleCount* 4);
				vertexColors[i] = malloc(sizeof(GLfloat) * 4 * particleCount * 4);
				textureCoords[i] = malloc(sizeof(GLfloat) * 2 * particleCount * 4);
				normals[i] = calloc(sizeof(GLfloat) * particleCount, 6);
				break;
			}		
			case ParticleEmitter3DDrawLines:
			{
				vertices[i] = malloc(sizeof(GLfloat) * 3 * particleCount* 2);
				vertexColors[i] = malloc(sizeof(GLfloat) * 4 * particleCount * 2);
				textureCoords[i] = NULL;
				normals[i] = NULL;
				break;
			}
			case ParticleEmitter3DDrawTriangles:
			{
				vertices[i] = malloc(sizeof(GLfloat) * 3 * particleCount * 3);
				vertexColors[i] = malloc(sizeof(GLfloat) * 4 * particleCount * 3);
				textureCoords[i] = NULL;
				normals[i] = NULL;
				break;
			}
			case ParticleEmitter3DDrawDiamonds:
			{
				vertices[i] = malloc(sizeof(GLfloat) * 3 * particleCount * 6);
				vertexColors[i] = malloc(sizeof(GLfloat) * 4 * particleCount * 6);				
				textureCoords[i] = NULL;
				normals[i] = NULL;
				break;
			}
			case ParticleEmitter3DDrawCircles:
			{
				vertices[i] = malloc(sizeof(GLfloat) * 3 * particleCount * 11);
				vertexColors[i] = malloc(sizeof(GLfloat) * 4 * particleCount * 11);
				textureCoords[i] = NULL;
				normals[i] = NULL;
				break;
			}
			default:
			break;		
		}
	}
}

//daellocate arrays for drawing elements
- (void)deallocArrays
{
	
	//dealloc second dimensions
	for(int i = 0; i<[self.particleEmitters count]; i++) 
	{
		if(vertices!=NULL){
			if (vertices[i] != NULL) 
			{
				free(vertices[i]);
				vertices[i] = NULL;
			}
		}
		if(vertexColors!=NULL) {
			if (vertexColors[i] != NULL)
			{
				free(vertexColors[i]);
				vertexColors[i] = NULL;
			}
		}
		
		if (textureCoords != NULL)
		{
			if (textureCoords[i] != NULL)
			{
				free(textureCoords[i]);
				textureCoords[i] = NULL;
			}
		}
		if (normals != NULL)
		{
			if (normals[i] != NULL)
			{
				free(normals[i]);
				normals[i] = NULL;
			}
		}	
	}
	//dealloc first dimensions
	if (vertices != NULL) 
	{
		free(vertices);
		vertices = NULL;
	}
	if (vertexColors != NULL)
	{
		free(vertexColors);
		vertexColors = NULL;
	}
	if (textureCoords != NULL)
	{
		free(textureCoords);
		textureCoords = NULL;
	}
	if (normals != NULL)
	{
		free(normals);
		normals = NULL;
	}
	
}


// Initial settings
- (void) setupRenderer:(EAGLView*)view {
	
	NSLog(@"Setup Renderer");
	
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	
	glEnable (GL_BLEND);	
	
	
	glLoadIdentity(); 
	
	vertices = NULL;
	vertexColors=NULL;
	textureCoords=NULL;
	normals=NULL;
	
	self.particleEmitters = [NSMutableArray array];
	
	//NoneTextured Ones
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase squareEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase circleEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase triangleEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase diamondEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase neonBlueExplosionEmitter]];
	
	//Textured Ones
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase balloonFly]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase fountainEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase explosionEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase torchEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase confettiParticleEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase fireEmitter]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase whiteBurst]];
	[self.particleEmitters addObject:[ParticleEmitter3DDatabase pixieDust]];

	
	//Start all emitters
	/*for(int i=0; i<[self.particleEmitters count]; i++) {
		[[self.particleEmitters objectAtIndex:i] startEmitter];
	}*/
	
	
}

- (void)render:(EAGLView*)view
{
	// Make sure that you are drawing to the current context
	[EAGLContext setCurrentContext:context];
	
	static int setup=0;
	if(setup == 0) {
		[self setupRenderer:view];
		setup=1;
	}
	//Update particle data by core operations
	
	for(int j=0;j<[self.particleEmitters count]; j++) {
		[[self.particleEmitters objectAtIndex:j] processParticles];
	}
	

	[self allocArrays];
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	
#pragma mark ClearColor
	
	//Set Background Color of View
	Color3D backgroundColor = Color3DMake(0,0,0,0);
	glClearColor(backgroundColor.red,backgroundColor.green,backgroundColor.blue,0);
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
	
	glColor4f(1.0, 1.0, 1.0, 1.0);

	glPushMatrix();
	glLoadIdentity();
	
	[OpenGLTexture3D useDefaultTexture];
	
	glTranslatef(0, 0, 0);
	
#pragma mark RotationProblem Here
	
	for(int i = 0; i < [self.particleEmitters count]; i++) {
		int particleCounter=0;	
		int particleCount = [[self.particleEmitters objectAtIndex:i] particleCount];
		Particle3D *present = [[self.particleEmitters objectAtIndex:i] particles];
		if(particleCount !=0) {
			switch ([[self.particleEmitters objectAtIndex:i] mode]) 
			{
				case ParticleEmitter3DDrawPoints:
				{
					while (present)
					{
						Vertex3D *partPosition = &present->position;
						vertices[i][(particleCounter * 3)] = partPosition->x;
						vertices[i][(particleCounter * 3) + 1] = partPosition->y;
						vertices[i][(particleCounter * 3) + 2] = partPosition->z;
						Color3D *partColor = &present->color;
						vertexColors[i][(particleCounter * 4)] = partColor->red;
						vertexColors[i][(particleCounter * 4) + 1] = partColor->green;
						vertexColors[i][(particleCounter * 4) + 2] = partColor->blue;
						vertexColors[i][(particleCounter * 4) + 3] = partColor->alpha;
						
						present = present->next;
						particleCounter++;
					}
					
					glEnableClientState(GL_VERTEX_ARRAY);
					glEnableClientState (GL_COLOR_ARRAY);
					glBindTexture(GL_TEXTURE_2D, 0);
					glColorPointer(4, GL_FLOAT, 0, vertexColors[i]);
					glVertexPointer(3, GL_FLOAT, 0, vertices[i]);
					glDrawArrays(GL_POINTS, 0, [[self.particleEmitters objectAtIndex:i] particleCount]);
					glDisableClientState(GL_VERTEX_ARRAY);
					glDisableClientState(GL_COLOR_ARRAY);
					
					
					break;
				}
				case ParticleEmitter3DDrawLines:
				{			
					while (present)
					{
						Vertex3D *startPoint = &present->position;
						vertices[i][(particleCounter * 6)] = startPoint->x;
						vertices[i][(particleCounter * 6) + 1] = startPoint->y;
						vertices[i][(particleCounter * 6) + 2] = startPoint->z;
						
						Vertex3D *endPoint = &present->lastPosition;
						vertices[i][(particleCounter * 6) + 3] = endPoint->x;
						vertices[i][(particleCounter * 6) + 4] = endPoint->y;
						vertices[i][(particleCounter * 6) + 5] = endPoint->z;
						
						Color3D *partColor = &present->color;
						vertexColors[i][(particleCounter * 8)] = partColor->red;
						vertexColors[i][(particleCounter * 8) + 1] = partColor->green;
						vertexColors[i][(particleCounter * 8) + 2] = partColor->blue;
						vertexColors[i][(particleCounter * 8) + 3] = partColor->alpha;
						vertexColors[i][(particleCounter * 8) + 4] = partColor->red;
						vertexColors[i][(particleCounter * 8) + 5] = partColor->green;
						vertexColors[i][(particleCounter * 8) + 6] = partColor->blue;
						vertexColors[i][(particleCounter * 8) + 7] = partColor->alpha;
						
						present = present->next;
						particleCounter++;
					}
					glEnableClientState(GL_VERTEX_ARRAY);
					glEnableClientState (GL_COLOR_ARRAY);
					glBindTexture(GL_TEXTURE_2D, 0);
					glColorPointer(4, GL_FLOAT, 0, vertexColors[i]);
					glVertexPointer(3, GL_FLOAT, 0, vertices[i]);
					glDrawArrays(GL_LINES, 0, particleCounter*2);
					glDisableClientState(GL_VERTEX_ARRAY);
					glDisableClientState(GL_COLOR_ARRAY);
					break;
				}	
				case ParticleEmitter3DDrawTriangles:
				{				
					while (present)
					{
						Vertex3D *point1 = &present->position;
						vertices[i][(particleCounter * 9)] = point1->x - PolyScale;
						vertices[i][(particleCounter * 9) + 1] = point1->y - PolyScale;
						vertices[i][(particleCounter * 9) + 2] = point1->z;
						vertices[i][(particleCounter * 9) + 3] = point1->x;
						vertices[i][(particleCounter * 9) + 4] = point1->y + PolyScale;
						vertices[i][(particleCounter * 9) + 5] = point1->z;
						vertices[i][(particleCounter * 9) + 6] = point1->x + PolyScale;
						vertices[i][(particleCounter * 9) + 7] = point1->y - PolyScale;
						vertices[i][(particleCounter * 9) + 8] = point1->z;
						
						Color3D *partColor = &present->color;
						for(int j =0;j<3;j++) {
							vertexColors[i][(particleCounter * 12) + 0 + 4*j] = partColor->red;
							vertexColors[i][(particleCounter * 12) + 1 + 4*j] = partColor->green;
							vertexColors[i][(particleCounter * 12) + 2 + 4*j] = partColor->blue;
							vertexColors[i][(particleCounter * 12) + 3 + 4*j] = partColor->alpha;
						}
						present = present->next;
						particleCounter++;
					}
					billboardCurrentMatrix();
					glEnableClientState(GL_VERTEX_ARRAY);
					glEnableClientState (GL_COLOR_ARRAY);
					glBindTexture(GL_TEXTURE_2D, 0);
					glColorPointer(4, GL_FLOAT, 0, vertexColors[i]);
					glVertexPointer(3, GL_FLOAT, 0, vertices[i]);
					glDrawArrays(GL_TRIANGLES, 0, particleCounter*3);
					glDisableClientState(GL_VERTEX_ARRAY);
					glDisableClientState(GL_COLOR_ARRAY);
					break;
				}
				case ParticleEmitter3DDrawDiamonds:
				{				
					while (present)
					{
						Vertex3D *point1 = &present->position;
						
						vertices[i][(particleCounter * 18)] = point1->x - PolyScale;
						vertices[i][(particleCounter * 18) + 1] = point1->y;
						vertices[i][(particleCounter * 18) + 2] = point1->z;
						
						vertices[i][(particleCounter * 18) + 3] = point1->x;
						vertices[i][(particleCounter * 18) + 4] = point1->y + PolyScale;
						vertices[i][(particleCounter * 18) + 5] = point1->z;
						
						vertices[i][(particleCounter * 18) + 6] = point1->x + PolyScale;
						vertices[i][(particleCounter * 18) + 7] = point1->y;
						vertices[i][(particleCounter * 18) + 8] = point1->z;
						
						vertices[i][(particleCounter * 18) + 9] = point1->x - PolyScale;
						vertices[i][(particleCounter * 18) + 10] = point1->y;
						vertices[i][(particleCounter * 18) + 11] = point1->z;
						
						vertices[i][(particleCounter * 18) + 12] = point1->x + PolyScale;
						vertices[i][(particleCounter * 18) + 13] = point1->y;
						vertices[i][(particleCounter * 18) + 14] = point1->z;
						
						vertices[i][(particleCounter * 18) + 15] = point1->x;
						vertices[i][(particleCounter * 18) + 16] = point1->y - PolyScale;
						vertices[i][(particleCounter * 18) + 17] = point1->z;
						
						Color3D *partColor = &present->color;
						for(int j=0;j<6;j++) {
							vertexColors[i][(particleCounter * 24) + 0 +4*j] = partColor->red;
							vertexColors[i][(particleCounter * 24) + 1 +4*j] = partColor->green;
							vertexColors[i][(particleCounter * 24) + 2 +4*j] = partColor->blue;
							vertexColors[i][(particleCounter * 24) + 3 +4*j] = partColor->alpha;
						}					
						present = present->next;
						particleCounter++;
					}
					billboardCurrentMatrix();
					glEnableClientState(GL_VERTEX_ARRAY);
					glEnableClientState (GL_COLOR_ARRAY);
					glBindTexture(GL_TEXTURE_2D, 0);
					glColorPointer(4, GL_FLOAT, 0, vertexColors[i]);
					glVertexPointer(3, GL_FLOAT, 0, vertices[i]);
					glDrawArrays(GL_TRIANGLES, 0, particleCounter*6);
					glDisableClientState(GL_VERTEX_ARRAY);
					glDisableClientState(GL_COLOR_ARRAY);
					break;
				}
					
				case ParticleEmitter3DDrawCircles:
				{				
					while (present)
					{
						Vertex3D *point1 = &present->position;
						
						vertices[i][(particleCounter * 33)] = point1->x + (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 1] = point1->y + (0.005000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 2] = point1->z;
						
						vertices[i][(particleCounter * 33) + 3] = point1->x + (0.005000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 4] = point1->y + (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 5] = point1->z;
						
						vertices[i][(particleCounter * 33) + 6] = point1->x;
						vertices[i][(particleCounter * 33) + 7] = point1->y + (0.010000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 8] = point1->z;
						
						vertices[i][(particleCounter * 33) + 9] = point1->x - (0.005000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 10] = point1->y + (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 11] = point1->z;
						
						vertices[i][(particleCounter * 33) + 12] = point1->x - (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 13] = point1->y + (0.005000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 14] = point1->z;
						
						vertices[i][(particleCounter * 33) + 15] = point1->x - (0.010000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 16] = point1->y;
						vertices[i][(particleCounter * 33) + 17] = point1->z;
						
						vertices[i][(particleCounter * 33) + 18] = point1->x - (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 19] = point1->y - (0.00500 * present->particleSize);
						vertices[i][(particleCounter * 33) + 20] = point1->z;
						
						vertices[i][(particleCounter * 33) + 21] = point1->x - (0.005000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 22] = point1->y - (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 23] = point1->z;
						
						vertices[i][(particleCounter * 33) + 24] = point1->x;
						vertices[i][(particleCounter * 33) + 25] = point1->y - (0.010000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 26] = point1->z;
						
						vertices[i][(particleCounter * 33) + 27] = point1->x + (0.005000 * present->particleSize);
						vertices[i][(particleCounter * 33) + 28] = point1->y - (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 29] = point1->z;
						
						vertices[i][(particleCounter * 33) + 30] = point1->x + (0.008660 * present->particleSize);
						vertices[i][(particleCounter * 33) + 31] = point1->y - (0.00500 * present->particleSize);
						vertices[i][(particleCounter * 33) + 32] = point1->z;
						
						Color3D *partColor = &present->color;
						for(int j=0;j<11;j++) {
							vertexColors[i][(particleCounter * 44) + 0 + j*4] = partColor->red;
							vertexColors[i][(particleCounter * 44) + 1 + j*4] = partColor->green;
							vertexColors[i][(particleCounter * 44) + 2 + j*4] = partColor->blue;
							vertexColors[i][(particleCounter * 44) + 3 + j*4] = partColor->alpha;
						}
						present = present->next;
						particleCounter++;
					}
					billboardCurrentMatrix();
					glEnableClientState(GL_VERTEX_ARRAY);
					glEnableClientState (GL_COLOR_ARRAY);
					glBindTexture(GL_TEXTURE_2D, 0);
					glColorPointer(4, GL_FLOAT, 0, vertexColors[i]);
					glVertexPointer(3, GL_FLOAT, 0, vertices[i]);
					//glDrawArrays(GL_TRIANGLE_FAN, 0, currentParticleCount*11);
					for (int j = 0; j < particleCounter; j++)
					{
						GLushort indices[] = {(j*11), (j*11)+1, (j*11)+2, (j*11)+3, (j*11)+4, (j*11)+5, (j*11)+6, (j*11)+7, (j*11)+8, (j*11)+9, (j*11)+10};
						glDrawElements(GL_TRIANGLE_FAN, 11, GL_UNSIGNED_SHORT, indices);
					}
					glDisableClientState(GL_VERTEX_ARRAY);
					glDisableClientState(GL_COLOR_ARRAY);				
					break;
				}
				case ParticleEmitter3DDrawSquares:
				case ParticleEmitter3DDrawTextureMap:
				{	
					if ([[self.particleEmitters objectAtIndex:i] mode] == ParticleEmitter3DDrawTextureMap)
						[[[self.particleEmitters objectAtIndex:i] texture] bind];
					else
						[OpenGLTexture3D useDefaultTexture];
					
					while (present)
					{
						
						Vertex3D *point1 = &present->position;
						vertices[i][(particleCounter * 12)] = point1->x + PolyScale;
						
						vertices[i][(particleCounter * 12) + 1] = point1->y + PolyScale;
						vertices[i][(particleCounter * 12) + 2] = point1->z;
						
						vertices[i][(particleCounter * 12) + 3] = point1->x - PolyScale;
						vertices[i][(particleCounter * 12) + 4] = point1->y + PolyScale;
						vertices[i][(particleCounter * 12) + 5] = point1->z;
						
						vertices[i][(particleCounter * 12) + 6] = point1->x + PolyScale;
						vertices[i][(particleCounter * 12) + 7] = point1->y - PolyScale;
						vertices[i][(particleCounter * 12) + 8] = point1->z;
						
						vertices[i][(particleCounter * 12) + 9] = point1->x - PolyScale;
						vertices[i][(particleCounter * 12) + 10] = point1->y - PolyScale;
						vertices[i][(particleCounter * 12) + 11] = point1->z;
						
						if ([[self.particleEmitters objectAtIndex:i] mode] == ParticleEmitter3DDrawTextureMap)
						{
							textureCoords[i][(particleCounter * 8)] = 1.0;
							textureCoords[i][(particleCounter * 8) + 1] = 1.0;
							textureCoords[i][(particleCounter * 8) + 2] = 0.0;
							textureCoords[i][(particleCounter * 8) + 3] = 1.0;
							textureCoords[i][(particleCounter * 8) + 4] = 1.0;
							textureCoords[i][(particleCounter * 8) + 5] = 0.0;
							textureCoords[i][(particleCounter * 8) + 6] = 0.0;
							textureCoords[i][(particleCounter * 8) + 7] = 0.0;
						}
						
						Color3D *partColor = &present->color;
						for(int j=0;j<4;j++) {
							vertexColors[i][(particleCounter * 16) + 0 + j*4] = partColor->red;
							vertexColors[i][(particleCounter * 16) + 1 + j*4] = partColor->green;
							vertexColors[i][(particleCounter * 16) + 2 + j*4] = partColor->blue;
							vertexColors[i][(particleCounter * 16) + 3 + j*4] = partColor->alpha;
						}
						present = present->next;
						particleCounter++;
					}
					glEnableClientState(GL_VERTEX_ARRAY);
					glEnableClientState (GL_COLOR_ARRAY);
					
					if ([[self.particleEmitters objectAtIndex:i] mode] == ParticleEmitter3DDrawTextureMap)
					{
#pragma mark Binding Removal (Not Sure)
					//	[[[self.particleEmitters objectAtIndex:i] texture] bind];
						
						glEnable (GL_BLEND);
						glBlendFunc(GL_SRC_ALPHA,GL_DST_ALPHA);
						glAlphaFunc( GL_GREATER, 0.6);
						glEnable( GL_ALPHA_TEST );
						
						glDisable(GL_DEPTH_TEST);
						glEnable(GL_TEXTURE_2D);
						glEnable(GL_POINT_SPRITE_OES);
						glEnableClientState(GL_TEXTURE_COORD_ARRAY);
						glEnableClientState(GL_NORMAL_ARRAY);
						glTexCoordPointer(2, GL_FLOAT, 0, textureCoords[i]);
						glNormalPointer(GL_FLOAT, 0, normals[i]);
					}
					
					billboardCurrentMatrix();
					glColorPointer(4, GL_FLOAT, 0, vertexColors[i]);
					glVertexPointer(3, GL_FLOAT, 0, vertices[i]);
					for (int j = 0; j < particleCounter; j++)
					{
						GLushort indices[] = {(j*4), (j*4)+1, (j*4)+2, (j*4)+3};
						glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, indices);
					}
					
					glDisableClientState(GL_VERTEX_ARRAY);
					glDisableClientState(GL_COLOR_ARRAY);
					if ([[self.particleEmitters objectAtIndex:i] mode] == ParticleEmitter3DDrawTextureMap)
					{
						glDisable(GL_TEXTURE);
						glDisable(GL_TEXTURE_2D);
						glDisable(GL_BLEND);
						glDisable(GL_ALPHA_TEST);
						glDisable(GL_POINT_SPRITE_OES);
						glDisableClientState(GL_NORMAL_ARRAY);
						glDisableClientState(GL_TEXTURE_COORD_ARRAY);
						glEnable(GL_DEPTH_TEST);
					}
					break;
				}				
				default:
					break;
			}
		}
	}
	glPopMatrix();

	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	[self deallocArrays];

}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
	
    return YES;
}

- (void)dealloc
{
	[self deallocArrays];
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }
	
    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
	
    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
    [context release];
    context = nil;
	
    [super dealloc];
}

@end
