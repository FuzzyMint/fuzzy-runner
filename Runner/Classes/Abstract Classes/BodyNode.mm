//
//  BodyNode.m
//  PhysicsBox2d
//
//  Created by Steffen Itterheim on 21.09.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//
//  Enhanced to use PhysicsEditor shapes and retina display
//  by Andreas Loew / http://www.physicseditor.de
//

#import "BodyNode.h"

@implementation BodyNode

@synthesize body;

-(id) initWithShape:(NSString*)shapeName andFrameName:(NSString*)frameName inWorld:(b2World*)world
{
    NSAssert(world != NULL, @"world is null!");
    NSAssert(shapeName != nil, @"name is nil!");
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSpriteFrame *frame = [frameCache spriteFrameByName:frameName];
    //Change to sprite by frame name
    self = [super initWithSpriteFrame:frame];
    
    
    if (self)
    {        
        
		//
        [self setDisplayFrame:frame];

        // create the body
        b2BodyDef bodyDef;
        body = world->CreateBody(&bodyDef);
        body->SetUserData(self);
        
        // set the shape
        [self setBodyShape:shapeName];
    }
    return self;
}

-(id) initWithWorld:(b2World*)world
{
    NSAssert(world != NULL, @"world is null!");
    //NSAssert(frameName != nil, @"name is nil!");
    
    //CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
   // CCSpriteFrame *frame = [frameCache spriteFrameByName:frameName];
   // self = [super initWithSpriteFrame:frame];
    
    self = [super init];
    
    if (self)
    {        
        // create the body
        b2BodyDef bodyDef;
        body = world->CreateBody(&bodyDef);
        body->SetUserData(self);
 
    }
    return self;
}

-(void) setBodyShape:(NSString*)shapeName
{
    // remove any existing fixtures from the body
    b2Fixture* fixture;
    while ((fixture = body->GetFixtureList()))
    {
        body->DestroyFixture(fixture);
    }

    // attach a new shape from the shape cache
    if (shapeName)
    {
        GB2ShapeCache* shapeCache = [GB2ShapeCache sharedShapeCache];
        [shapeCache addFixturesToBody:body forShapeName:shapeName];
        self.anchorPoint = [shapeCache anchorPointForShape:shapeName];
    }
}

-(void) dealloc
{
    // remove the body from the world
    body->GetWorld()->DestroyBody(body);

	[super dealloc];
}

// this method will only get called if the sprite is batched.
// return YES if the physics values (angles, position ) changed
// If you return NO, then nodeToParentTransform won't be called.
-(BOOL) dirty
{
	return YES;
}

// returns the transform matrix according the Box2D Body values
-(CGAffineTransform) nodeToParentTransform
{	
	b2Vec2 pos  = body->GetPosition();
	
	float x = pos.x * PTM_RATIO;
	float y = pos.y * PTM_RATIO;
	
	if ( ignoreAnchorPointForPosition_ ) {
		x += anchorPointInPoints_.x;
		y += anchorPointInPoints_.y;
	}
	
	// Make matrix
	float radians = body->GetAngle();
	float c = cosf(radians);
	float s = sinf(radians);
	
	if( ! CGPointEqualToPoint(anchorPointInPoints_, CGPointZero) ){
		x += c*-anchorPointInPoints_.x + -s*-anchorPointInPoints_.y;
		y += s*-anchorPointInPoints_.x + c*-anchorPointInPoints_.y;
	}
	
	// Rot, Translate Matrix
	transform_ = CGAffineTransformMake( c,  s,
									   -s,	c,
									   x,	y );	
	
	return transform_;
}

@end
