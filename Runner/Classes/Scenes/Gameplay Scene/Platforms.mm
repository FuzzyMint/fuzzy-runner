//
//  Platforms.m
//  Runner
//
//  Created by Yusuf Sobh on 7/28/12.
//  Copyright (c) 2012 TwoPlusOne. All rights reserved.
//

#import "Platforms.h"
#import "Platform.h"

@interface Platforms ()
{
    float xOffset;
    float yOffset;
    Platform *currentPlatform;
}

@end

@implementation Platforms

- (id) initPlatformsWithWorld:(b2World*)world
{
    if ((self = [super initWithFile:@"TexturePackerFile.plist" capacity:5]))
	{
        
        [self addChild:[Platform platformWithWorld:world position:ccp(0,0)]];
        [self addChild:[Platform platformWithWorld:world position:ccp(200 + 100,0)]];
        [self addChild:[Platform platformWithWorld:world position:ccp(500 + 100,0)]];
    
        [self scheduleUpdate];
    }
    
    return self;
    
}

+ (id)setupPlatformsWithWorld:(b2World*)world
{
	return [[[self alloc] initPlatformsWithWorld:world] autorelease];
}

- (void)update
{
    CCARRAY_FOREACH(self.children, currentPlatform)
    {
        if( (currentPlatform.body->GetPosition().x * PTM_RATIO) + currentPlatform.width < 0) {
            [self repositionPlatform:currentPlatform];
        }
    }
    
}

- (void) repositionPlatform:(Platform *)platform
{
    CCLOG(@"MOVE PLATFORM TO FRONT");
}


@end
