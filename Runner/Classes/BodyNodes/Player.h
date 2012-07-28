//
//  Player.h
//  Runner
//
//  Created by Yusuf Sobh on 7/27/12.
//  Copyright (c) 2012 TwoPlusOne. All rights reserved.
//

#import "BodyNode.h"

@interface Player : BodyNode <CCTargetedTouchDelegate>
{
    bool isTouchingGround;
    bool jumpInProgress;
    float jumpStrength;
}

/**
 * Creates a new ball
 * @param world world to add the ball to
 */
+(id) playerWithWorld:(b2World*)world;

@end
