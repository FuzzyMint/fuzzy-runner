//
//  Platforms.h
//  Runner
//
//  Created by Yusuf Sobh on 7/28/12.
//  Copyright (c) 2012 TwoPlusOne. All rights reserved.
//

#import "CCSpriteBatchNode.h"
#import "BodyNode.h"

@interface Platforms : CCSpriteBatchNode

+ (id)setupPlatformsWithWorld:(b2World*)world;

@end
