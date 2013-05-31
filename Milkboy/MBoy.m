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
@property (nonatomic, assign, readwrite) CGRect boundCollision;
@property (nonatomic, assign, readwrite) uint32_t powerInteger;
@property (nonatomic, assign, readwrite) uint32_t powerIntegerMax;
@property (nonatomic, assign, readwrite) uint32_t powerDecimal;
@property (nonatomic, assign, readwrite) uint32_t powerDecimalMax;
@property (nonatomic, assign, readwrite) uint32_t powerDecimalDelta;
@property (nonatomic, strong) CCSprite* spriteBoy;
@property (nonatomic, strong) CCSprite* spriteHat;
@property (nonatomic, strong) CCSprite* spritePowerBase;
@property (nonatomic, strong) CCSprite* spritePowerMask;
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
        self.sprite = [CCSpriteBatchNode batchNodeWithFile:@"Texture/char.pvr.ccz" capacity:4];

        //--nearest sampling
        [self.sprite.texture setAliasTexParameters];

        //--boy sprite
        self.spriteBoy = [CCSprite spriteWithSpriteFrameName:@"char_move_00.png"];

        self.spriteBoy.scale = 2.0f;
        self.spriteBoy.position = ccp(160.0f, 240.0f);

        [self.sprite addChild:self.spriteBoy z:0];

        //--hat sprite
        self.spriteHat = [CCSprite spriteWithSpriteFrameName:@"char_hat_dash.png"];

        self.spriteHat.scale = 2.0f;
        self.spriteHat.position = ccp(160.0f, 240.0f);

        [self.sprite addChild:self.spriteHat z:1];

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
        self.boundCollision = CGRectMake(-11.0f, -22.0f, 22.0f, 44.0f);

        self.position = CGPointMake(25.0f, 23.0f);
        self.velocity = CGPointMake(3.0f, 0.0f);
        self.acceleration = CGPointMake(0.0f, -2.0f);

        self.powerInteger      = 0;
        self.powerIntegerMax   = 3;
        self.powerDecimal      = 0;
        self.powerDecimalMax   = 5;
        self.powerDecimalDelta = 1;

        //--power ui
        self.spritePowerBase = [CCSprite spriteWithSpriteFrameName:@"char_power_back.png"];
        self.spritePowerMask = [CCSprite spriteWithSpriteFrameName:@"char_power_mark.png"];

        self.spritePowerBase.scaleY = 2.0f;
        self.spritePowerMask.scaleY = 2.0f;

        [self.sprite addChild:self.spritePowerBase z:10];
        [self.sprite addChild:self.spritePowerMask z:11];

        [self updatePowerUI];
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

        //
        CGPoint v = ccpSub(self.spritePowerMask.position, self.spritePowerBase.position);

        CGPoint p = position;

        p.y += 32.0f;

        self.spritePowerBase.position = p;

        p = ccpAdd(p, v);

        self.spritePowerMask.position = p;
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
-(void) updatePower:(BOOL)powerUp
{
    BOOL updateUI = FALSE;

    if (powerUp)
    {
        if (self.step && (self.powerInteger < self.powerIntegerMax))
        {
            self.powerDecimal += self.powerDecimalDelta;

            if (self.powerDecimal >= self.powerDecimalMax)
            {
                self.powerDecimal -= self.powerDecimalMax;

                self.powerInteger += 1;

                updateUI = TRUE;
            }
        }
    }
    else
    {
        if (self.powerInteger || self.powerDecimal)
        {
            self.powerInteger = 0;
            self.powerDecimal = 0;

            updateUI = TRUE;
        }
    }

    if (updateUI)
    {
        [self updatePowerUI];
    }
}

//------------------------------------------------------------------------------
-(void) updatePowerUI
{
    CGPoint p = self->_position;

    p.y += 32.0f;

    self.spritePowerBase.scaleX = 4.0f * ((float)(self.powerIntegerMax + 2) / 12.0f);

    self.spritePowerBase.position = p;

    self.spritePowerMask.scaleX = 4.0f * ((float)(self.powerInteger) / 10.0f);

    self.spritePowerMask.position = p;
}

//------------------------------------------------------------------------------
-(BOOL) drinkMilk:(uint32_t)count
{
    BOOL levelUp = FALSE;

    self->_milkCount += count;

    if (self->_milkCount >= 10)
    {
        levelUp = TRUE;

        self->_powerIntegerMax += self->_milkCount / 10;

        self->_milkCount %= 10;

        [self updatePowerUI];
    }

    return levelUp;
}

//------------------------------------------------------------------------------
@end
