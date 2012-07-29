//
//  Platform.m
//  Runner
//
//  Created by Yusuf Sobh on 7/28/12.
//  Copyright (c) 2012 TwoPlusOne. All rights reserved.
//

#import "Platform.h"


@implementation Platform

static Platform *lastGuy;

@synthesize width = _width, height = _height;

-(id) initWithWorld:(b2World*)world position:(CGPoint)pos
{    
    
	if ((self = [super initWithWorld:world andTexture:@"GreenBlock.PNG" width:_width * 0.5f height:_height * 0.5f]))
	{
                        
        float variableSpace = 40;
        
        CGPoint newPosition;
        
        if(lastGuy == nil) {
            newPosition = ccp(50, 80);  
        } else {
            newPosition = ccp([lastGuy getPositionByUpperLeftInPixels].x + lastGuy.width + variableSpace, 80);  
        }
    
        CGSize newSize = CGSizeMake(300 + CCRANDOM_0_1() * 300 , 20);
        
        [self resetPlatformWithSize:newSize andPosition:newPosition];
        
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
    lastGuy = nil;
    
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    if([self getPositionByUpperLeftInPixels].x + _width < 0){
        
        float variableSpace = 40;
        
        CGPoint newPosition = ccp([lastGuy getPositionByUpperLeftInPixels].x + lastGuy.width + variableSpace, 80);  
        
        CGSize newSize = CGSizeMake(100 + CCRANDOM_0_1() * 300 , 20);
        
        [self resetPlatformWithSize:newSize andPosition:newPosition];
                
    }

}       

-(CGPoint) getPositionByUpperLeftInPixels
{
    return ccpSub([Helper toPixels:body->GetPosition()], ccp(_width/2, _height/2));
}

-(void) setPositionByUpperLeftInPixels:(CGPoint)position
{
    position = ccpAdd(position, ccp(_width/2, _height/2));
    self.body->SetTransform([Helper toMeters:position], 0);
}

-(void) resetPlatformWithSize:(CGSize)size andPosition:(CGPoint)resetPosition
{
    // remove any existing fixtures from the body
    b2Fixture* fixture;
    while ((fixture = body->GetFixtureList()))
    {
        body->DestroyFixture(fixture);
    }
    
    _width = size.width;
    _height = size.height;
    
    [self setTextureRect: CGRectMake(0.0, 0.0, _width, _height)];
    
    b2PolygonShape screenBoxShape;
    screenBoxShape.SetAsBox(_width * 0.5f / PTM_RATIO, _height * 0.5f / PTM_RATIO);
    
    float density = 0.0;
    fixture = body->CreateFixture(&screenBoxShape, density);
    
    b2Filter collisonFilter;
    collisonFilter.groupIndex = 0;
    collisonFilter.categoryBits = 0x0002; // category = Map Objects
    collisonFilter.maskBits = 0x0001 | 0x0002;     // mask = Player and Map Objects (including self?! Make separate category later if I want overlapping ground pieces)
    
    fixture->SetFilterData(collisonFilter);
    
    body->SetType(b2_kinematicBody);
    
    body->SetLinearVelocity(b2Vec2(-10.0,0.0));
    
    [self setPositionByUpperLeftInPixels:resetPosition];
    
    lastGuy = self;

}


@end
