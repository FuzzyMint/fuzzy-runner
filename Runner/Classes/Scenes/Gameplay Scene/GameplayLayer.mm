//
//  PinballTable.mm
//  PhysicsBox2d
//
//  Created by Steffen Itterheim on 16.09.10.
//  Copyright Steffen Itterheim 2010. All rights reserved.
//
//  Enhanced to use PhysicsEditor shapes and retina display
//  by Andreas Loew / http://www.physicseditor.de
//

#import "GameplayLayer.h"
#import "Constants.h"
#import "Helper.h"
#import "TableSetup.h"
#import "GB2ShapeCache.h"
#import "b2PolygonShape.h"
#import "b2Math.h"
#import "b2Body.h"
#import "b2Fixture.h"
#import "BodyNode.h"
#import "b2Settings.h"
#import "SimpleAudioEngine.h"

#import "Player.h"
#import "Platform.h"

@interface GameplayLayer (PrivateMethods)
-(void) initBox2dWorld;
-(void) enableBox2dDebugDrawing;
@end

@implementation GameplayLayer

+(id) scene
{
	CCScene* scene = [CCScene node];
	GameplayLayer* layer = [GameplayLayer node];
	[scene addChild:layer];
	return scene;
}


-(id) init
{
	if ((self = [super init]))
	{
		// pre load the sprite frames from the texture atlas
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TexturePackerFile.plist"];

        // load physics definitions
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"Shapes.plist"];

		// pre load audio effects
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"bumper.wav"];
		
        // init the box2d world
		[self initBox2dWorld];

        // debug drawing
		[self enableBox2dDebugDrawing];

		// load the background from the texture atlas
        //CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"background"];
        //background.anchorPoint = ccp(0,0);
        //background.position = ccp(0,0);
		//[self addChild:background z:-3];

		// Set up table elements
        Player* player = [Player playerWithWorld:world];
		[self addChild:player z:-1];
        
        Platform* platform = [Platform platformWithWorld:world];
        [self addChild:platform z:0];
        
		//TableSetup* tableSetup = [TableSetup setupTableWithWorld:world];
		//[self addChild:tableSetup z:-1];
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete contactListener;
	contactListener = NULL;
	
	delete debugDraw;
	debugDraw = NULL;
    
    [CCSpriteFrameCache purgeSharedSpriteFrameCache]; 
    [CCTextureCache purgeSharedTextureCache]; 

	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) initBox2dWorld
{
	// Construct a world object, which will hold and simulate the rigid bodies.
	b2Vec2 gravity = b2Vec2(0.0f, -15.0f);	
	world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);	
    
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);
}

-(void) enableBox2dDebugDrawing
{
	// Debug Draw functions
	debugDraw = new GLESDebugDraw(PTM_RATIO);
	world->SetDebugDraw(debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	debugDraw->SetFlags(flags);
}

-(void) update:(ccTime)delta
{
	static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    
    timeAccumulator += delta;    
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }    
    
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    while (timeAccumulator >= UPDATE_INTERVAL) {        
        timeAccumulator -= UPDATE_INTERVAL;        
        world->Step(UPDATE_INTERVAL, 
                    velocityIterations, positionIterations);        
    }
}

#ifdef DEBUG
-(void) draw
{
    [super draw];

	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
    	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}
#endif

@end
