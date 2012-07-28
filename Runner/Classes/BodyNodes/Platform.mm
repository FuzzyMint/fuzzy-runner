//
//  Platform.m
//  Runner
//
//  Created by Yusuf Sobh on 7/28/12.
//  Copyright (c) 2012 TwoPlusOne. All rights reserved.
//

#import "Platform.h"


@implementation Platform

@synthesize width = _width;

-(id) initWithWorld:(b2World*)world position:(CGPoint)pos
{    
    b2Vec2 platformStart = b2Vec2(0, 0);
	b2Vec2 platformEnd = b2Vec2(4, 0);
    
    _width = 600;
    b2PolygonShape screenBoxShape;
    screenBoxShape.SetAsBox(_width / PTM_RATIO, 20 / PTM_RATIO);
    
	if ((self = [super initWithWorld:world andTexture:@"bricks.jpg" width:_width height:20]))
	{
        float density = 0.0;
        
        // set the parameters
        b2Fixture *ground = body->CreateFixture(&screenBoxShape, density);
        
        b2Filter collisonFilter;
         collisonFilter.groupIndex = 0;
         collisonFilter.categoryBits = 0x0002; // category = Map Objects
         collisonFilter.maskBits = 0x0001 | 0x0002;     // mask = Player and Map Objects (including self?! Make separate category later if I want overlapping ground pieces)
         
        ground->SetFilterData(collisonFilter);
                
        body->SetTransform([Helper toMeters:pos], 0);
        
        body->SetType(b2_staticBody);

        [self scheduleUpdate];
        
	}
	return self;
}

+(id) platformWithWorld:(b2World*)world position:(CGPoint)pos
{
	return [[[self alloc] initWithWorld:world position:pos] autorelease];
}
        
-(void) dealloc
{
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    //self.body->SetTransform(b2Vec2(body->GetPosition().x - 5.00 * delta,body->GetPosition().y), 0);
}       
        
@end
