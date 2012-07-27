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
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pinball.plist"];

        // load physics definitions
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"pinball-shapes.plist"];

		// pre load audio effects
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"bumper.wav"];
		
        // init the box2d world
		[self initBox2dWorld];

        // debug drawing
		//[self enableBox2dDebugDrawing];

		// load the background from the texture atlas
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"background"];
        background.anchorPoint = ccp(0,0);
        background.position = ccp(0,0);
		[self addChild:background z:-3];

		// Set up table elements
		TableSetup* tableSetup = [TableSetup setupTableWithWorld:world];
		[self addChild:tableSetup z:-1];
		
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

	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) initBox2dWorld
{
	// Construct a world object, which will hold and simulate the rigid bodies.
	b2Vec2 gravity = b2Vec2(0.0f, -5.0f);	
	
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);	
    
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);
	
	// Define the static container body, which will provide the collisions at screen borders.
	b2BodyDef containerBodyDef;
	b2Body* containerBody = world->CreateBody(&containerBodyDef);

	// for the ground body we'll need these values
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	float widthInMeters = screenSize.width / PTM_RATIO;
	float heightInMeters = screenSize.height / PTM_RATIO;
	b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
	b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
	b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
	b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
	
	// Create the screen box' sides by using a polygon assigning each side individually.
	b2EdgeShape screenBoxShape;
	float density = 0.0;

	// We only need the sides for the table:
	// left side
	screenBoxShape.Set(upperLeftCorner, lowerLeftCorner);
	b2Fixture *left = containerBody->CreateFixture(&screenBoxShape, density);
	
	// right side
	screenBoxShape.Set(upperRightCorner, lowerRightCorner);
	b2Fixture *right = containerBody->CreateFixture(&screenBoxShape, density);

    // set the collision flags: category and mask
    b2Filter collisonFilter;
    collisonFilter.groupIndex = 0;
    collisonFilter.categoryBits = 0x0010; // category = Wall
    collisonFilter.maskBits = 0x0001;     // mask = Ball

    left->SetFilterData(collisonFilter);
    right->SetFilterData(collisonFilter);
}

-(void) enableBox2dDebugDrawing
{
	// Debug Draw functions
	debugDraw = new GLESDebugDraw([[CCDirector sharedDirector] contentScaleFactor] * PTM_RATIO);
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
