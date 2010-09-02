//
//  ES1Renderer.h
//  ParticleEmitter
//
//  Created by EBattal on 8/9/10.
//

#import "ESRenderer.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "ParticleEmitter3D.h"
#import "EAGLView.h"
#import "OpenGLTexture3D.h"

#define PolyScale (0.01 * present->particleSize)

@interface ES1Renderer : NSObject <ESRenderer>
{
	
	NSMutableArray				*particleEmitters;
	@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer;
	
	GLuint depthRenderbuffer;
	
	GLfloat						**vertices;				// All the vertices to be drawn
	GLfloat						**vertexColors;			// The colors of the vertices
	GLfloat						**textureCoords;			// The texture coordinates arrays
	GLfloat						**normals;				// The normals array
	
}

@property (nonatomic,retain) NSMutableArray *particleEmitters;

- (void)render:(EAGLView*)view;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
- (void)setupRenderer:(EAGLView*)view;
- (NSInteger)theoreticalMaxParticles:(ParticleEmitter3D *) emitter;
@end
