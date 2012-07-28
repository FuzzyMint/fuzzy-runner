//
//  Platform.m
//  Runner
//
//  Created by Yusuf Sobh on 7/28/12.
//  Copyright (c) 2012 TwoPlusOne. All rights reserved.
//

#import "Platform.h"

@implementation Platform

-(id) initWithWorld:(b2World*)world
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    b2Vec2 platformStart = b2Vec2(0, 0);
	b2Vec2 platformEnd = b2Vec2(4, 0);
    
    b2PolygonShape screenBoxShape;
    screenBoxShape.SetAsBox(1000 / PTM_RATIO, 20 / PTM_RATIO);
    
	if ((self = [super initWithWorld:world]))
	{
        float density = 0.0;
        
        // set the parameters
        body->SetType(b2_staticBody);
        b2Fixture *ground = body->CreateFixture(&screenBoxShape, density);
        
        b2Filter collisonFilter;
         collisonFilter.groupIndex = 0;
         collisonFilter.categoryBits = 0x0002; // category = Map Objects
         collisonFilter.maskBits = 0x0001 | 0x0002;     // mask = Player and Map Objects (including self?! Make separate category later if I want overlapping ground pieces)
         
        ground->SetFilterData(collisonFilter);
                
        body->SetTransform(b2Vec2(105 / PTM_RATIO, 10 / PTM_RATIO), 0);
        
        [self scheduleUpdate];
        
	}
	return self;
}

+(id) platformWithWorld:(b2World*)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}
        
-(void) dealloc
{
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    self.body->SetTransform(b2Vec2(body->GetPosition().x - 5.00 * delta,0), 0);
}       
        
@end
