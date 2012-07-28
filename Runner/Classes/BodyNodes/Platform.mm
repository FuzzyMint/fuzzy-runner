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
    b2Vec2 platformStart = b2Vec2(0, 0);
	b2Vec2 platformEnd = b2Vec2(100, 0);
    
    b2EdgeShape screenBoxShape;
	screenBoxShape.Set(platformStart, platformEnd);
    
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
        
@end
