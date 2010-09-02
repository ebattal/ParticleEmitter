//
//  EAGLView.m
//  ParticleEmitter
//
//  Created by EBattal on 8/9/10.

#import "EAGLView.h"

#import "ES1Renderer.h"
@implementation EAGLView

@synthesize animating;
@synthesize addNew, skip, stopOne, stopAll;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
    {
				
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		/* For iPhone 3G support, use OpenGL ES 1.1 or less */ 
        //renderer = [[ES2Renderer alloc] init];

		renderer = [[ES1Renderer alloc] init];

		if (!renderer)
		{
			[self release];
			return nil;
		}
     

        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;

        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
    }
    return self;
}

//Render 
- (void)drawView:(id)sender
{
	[renderer render:self];
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;

        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        if (displayLinkSupported)
        {
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.

            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];

        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }

        animating = FALSE;
    }
}

-(void)doAction:(int)action {
	NSMutableArray *temp = [renderer particleEmitters];
	static int indicator=0;
	switch (action) {
		case 0:
		{
			[[temp objectAtIndex:indicator] startEmitter];
			indicator++;

			break;
		}
		case 1:
		{
			for(int i =0;i<[temp count];i++) {
				[[temp objectAtIndex:i] stopEmitter];
			}
			[[temp objectAtIndex:indicator] startEmitter];
			indicator++;
			break;
		}
		case 2:
		{
			for(int i = 0;i<[temp count];i++) {
				if([[temp objectAtIndex:i] isEmitting] ==YES) {
					[[temp objectAtIndex:i] stopEmitter];
					break;
				}
			}
			break;
		}
		case 3:
		{
			for(int i = 0;i<[temp count];i++) {
				[[temp objectAtIndex:i] stopEmitter];
			}
			break;
		}
		default:
			break;
	}
	if(indicator>=[temp count]) {
		indicator =0;
	}
}
- (IBAction) actionAddNew 
{
	[self doAction:0];
}
- (IBAction) actionSkip
{
	[self doAction:1];
}
- (IBAction) actionStopOne
{
	[self doAction:2];
}
- (IBAction) actionStopAll
{
	[self doAction:3];
}


- (void)dealloc
{
    [renderer release];
    [super dealloc];
}

@end
