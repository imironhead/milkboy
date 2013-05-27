//
//  MBoy.m
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MBoy.h"


//------------------------------------------------------------------------------
typedef enum _MBoySpriteFrame
{
    MBoySpriteFrameMove0 = 0,
    MBoySpriteFrameMove1,
    MBoySpriteFrameMove2,
    MBoySpriteFrameMove3,
    MBoySpriteFrameMove4,
    MBoySpriteFrameMove5,
    MBoySpriteFrameMove6,
    MBoySpriteFrameMove7,
    MBoySpriteFrameJump,
    MBoySpriteFrameDown,
} MBoySpriteFrame;

//------------------------------------------------------------------------------
@interface MBoyLocal()
@property (nonatomic, strong, readwrite) CCSpriteBatchNode* sprite;
@property (nonatomic, assign, readwrite) URect boundCollision;
@property (nonatomic, strong) CCSprite* spriteBoy;
@property (nonatomic, strong) CCSprite* spriteHat;
@property (nonatomic, strong) NSMutableArray* framesBoy;
@property (nonatomic, strong) NSMutableArray* framesHat;
@property (nonatomic, assign) NSUInteger indexFrameBoy;
@end

//------------------------------------------------------------------------------
@implementation MBoyLocal
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--batch node
        self.sprite = [CCSpriteBatchNode batchNodeWithFile:@"Texture/char.pvr.ccz" capacity:2];

        //--nearest sampling
        [self.sprite.texture setAliasTexParameters];

        //--boy sprite
        self.spriteBoy = [CCSprite spriteWithSpriteFrameName:@"char_move_00.png"];

        self.spriteBoy.scale = 2.0f;
        self.spriteBoy.position = ccp(160.0f, 240.0f);

        [self.sprite addChild:self.spriteBoy];

        //--hat sprite
        self.spriteHat = [CCSprite spriteWithSpriteFrameName:@"char_hat_dash.png"];

        self.spriteHat.scale = 2.0f;
        self.spriteHat.position = ccp(160.0f, 240.0f);

        [self.sprite addChild:self.spriteHat];

        //--animation frames
        NSArray* frameNameBoy =
        @[
            @"char_move_00.png",
            @"char_move_01.png",
            @"char_move_02.png",
            @"char_move_03.png",
            @"char_move_04.png",
            @"char_move_05.png",
            @"char_move_06.png",
            @"char_move_07.png",
            @"char_jump.png",
            @"char_down.png",
        ];

        self.framesBoy = [NSMutableArray arrayWithCapacity:10];

        for (NSString* name in frameNameBoy)
        {
            [self.framesBoy addObject:
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
        }

        self.indexFrameBoy = 0;

        //--initial state
        self.boundCollision = URectMake(-11.0f, -22.0f, 11.0f, 22.0f);

        self.position = CGPointMake(25.0f, 23.0f);
        self.velocity = CGPointMake(3.0f, 0.0f);
        self.acceleration = CGPointMake(0.0f, -2.0f);

        self.power = 0.0f;
        self.powerAdd = 1.0f;
        self.powerMax = 30.0f;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) setPosition:(CGPoint)position
{
    if (!CGPointEqualToPoint(self->_position, position))
    {
        self->_position = position;

        self.spriteBoy.position = position;
        self.spriteHat.position = self.spriteBoy.position;

        CGPoint velocity = self->_velocity;

        if (velocity.y > 0.0f)
        {
            if (self.indexFrameBoy != MBoySpriteFrameJump)
            {
                self.indexFrameBoy = MBoySpriteFrameJump;

                [self.spriteBoy setDisplayFrame:self.framesBoy[MBoySpriteFrameJump]];
            }
        }
        else if (velocity.y < 0.0f)
        {
            if (self.indexFrameBoy != MBoySpriteFrameDown)
            {
                self.indexFrameBoy = MBoySpriteFrameDown;

                [self.spriteBoy setDisplayFrame:self.framesBoy[MBoySpriteFrameDown]];
            }
        }
        else
        {
            if (self.indexFrameBoy <= MBoySpriteFrameMove7)
            {
                self.indexFrameBoy = (1 + self.indexFrameBoy) % 8;
            }
            else
            {
                self.indexFrameBoy = MBoySpriteFrameMove0;
            }

            [self.spriteBoy setDisplayFrame:self.framesBoy[self.indexFrameBoy]];
        }
    }
}

//------------------------------------------------------------------------------
-(void) setVelocity:(CGPoint)velocity
{
    if (!CGPointEqualToPoint(self->_velocity, velocity))
    {
        self->_velocity = velocity;

        self.spriteBoy.flipX = (velocity.x < 0.0f);
        self.spriteHat.flipX = self.spriteBoy.flipX;
    }
}

//------------------------------------------------------------------------------
@end
