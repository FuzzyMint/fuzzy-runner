//
//  Player.m
//  Runner
//
//  Created by Yusuf Sobh on 7/27/12.
//  Copyright (c) 2012 TwoPlusOne. All rights reserved.
//

#import "Player.h"
#import "SimpleAudioEngine.h"

#define kJumpStrength 28

@implementation Player

-(id) initWithWorld:(b2World*)world
{
	if ((self = [super initWithShape:@"player-run-1" andFrameName:@"player_run_1" inWorld:world]))
	{
        // set the parameters
        body->SetType(b2_dynamicBody);
        body->SetFixedRotation(TRUE);
        
        // enable continuous collision detection
        body->SetBullet(true);
        
        
        // set random starting point
        [self setBallStartPosition];
        
        // enable handling touches
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        jumpStrength = kJumpStrength;
        
        // schedule updates
		[self scheduleUpdate];
	}
	return self;
}

+(id) playerWithWorld:(b2World*)world
{
	return [[[self alloc] initWithWorld:world] autorelease];
}

-(void) dealloc
{
	[[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
	[super dealloc];
}

-(void) setBallStartPosition
{
    // set the ball's position
    float randomOffset = CCRANDOM_0_1() * 10.0f - 5.0f;
    CGPoint startPos = CGPointMake(100 + randomOffset, 100);
    
    body->SetTransform([Helper toMeters:startPos], 0.0f);    
    body->SetLinearVelocity(b2Vec2_zero);
    body->SetAngularVelocity(0.0f);
}

-(void) update:(ccTime)delta
{
    if(jumpInProgress) {
        [self applyJumpForce];        
    }
	
	if (self.position.y < -(self.contentSize.height * 10))
	{
		// restart at a random position
		[self setBallStartPosition];
	}
}

- (void)applyJumpForce
{
    jumpStrength -= 2;
    if(jumpStrength <= 0) {
        jumpStrength = 0;
        jumpInProgress = NO;
    }
    
	b2Vec2 bodyPos = body->GetWorldCenter();
	b2Vec2 jumpForce = b2Vec2(0.0, jumpStrength);
	body->ApplyForce(jumpForce, body->GetWorldCenter());
}

- (void)endJump
{
    jumpInProgress = NO;
    [self unschedule:_cmd];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(isTouchingGround && !jumpInProgress)
    {
        jumpStrength = kJumpStrength;
        jumpInProgress = YES;
        [self scheduleOnce:@selector(endJump) delay:0.2];
    }
    
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    jumpInProgress = NO;
}

-(void) playSound
{
	float pitch = 0.9f + CCRANDOM_0_1() * 0.2f;
	float gain = 1.0f + CCRANDOM_0_1() * 0.3f;
	[[SimpleAudioEngine sharedEngine] playEffect:@"bumper.wav" pitch:pitch pan:0.0f gain:gain];
    
}

-(void) beginContactWithPlatform:(Contact*)contact
{
    isTouchingGround = YES;
}

-(void) endContactWithPlatform:(Contact*)contact
{
    isTouchingGround = NO;
}

-(void) endContactWithBumper:(Contact*)contact
{
	[self playSound];
}

-(void) endContactWithPlunger:(Contact*)contact
{
	[self playSound];
}


@end
