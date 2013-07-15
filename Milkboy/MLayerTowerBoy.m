//
//  MLayerTowerBoy.m
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTowerBoy.h"
#import "MSpriteTowerItem.h"
#import "MSpriteTowerStep.h"


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
@interface MLayerTowerBoy()
@property (nonatomic, assign, readwrite) CGRect boundCollision;
@property (nonatomic, assign, readwrite) uint32_t powerInteger;
@property (nonatomic, assign, readwrite) uint32_t powerIntegerMax;
@property (nonatomic, assign, readwrite) uint32_t powerDecimal;
@property (nonatomic, assign, readwrite) uint32_t powerDecimalMax;
@property (nonatomic, assign, readwrite) uint32_t powerDecimalDelta;
@property (nonatomic, assign, readwrite) uint32_t score;
@property (nonatomic, assign, readwrite) uint32_t catState;
@property (nonatomic, assign, readwrite) MBoyState boyState;
@property (nonatomic, strong) CCSpriteBatchNode* sprite;
@property (nonatomic, strong) CCSprite* spriteBoy;
@property (nonatomic, strong) CCSprite* spriteCat;
@property (nonatomic, strong) CCSprite* spriteHat;
@property (nonatomic, strong) CCSprite* spritePowerBase;
@property (nonatomic, strong) CCSprite* spritePowerMask;
@property (nonatomic, strong) NSMutableArray* framesBoy;
@property (nonatomic, strong) NSMutableArray* framesHat;
@property (nonatomic, assign) NSUInteger indexFrameBoy;
@property (nonatomic, assign) BOOL doubleJumped;
@property (nonatomic, assign) float highest;
@end

//------------------------------------------------------------------------------
@implementation MLayerTowerBoy
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--batch node
        self.sprite = [CCSpriteBatchNode batchNodeWithFile:@"Texture/char.pvr.ccz" capacity:4];

        [self addChild:self.sprite];

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

        //--cat sprite
        self.spriteCat = [CCSprite spriteWithSpriteFrameName:@"char_cat.png"];

        self.spriteCat.scale = 2.0f;
        self.spriteCat.visible = FALSE;
        self.spriteCat.position = ccp(160.0f, 240.0f);
        self.spriteCat.anchorPoint = ccp(0.5f, 0.0f);

        [self.sprite addChild:self.spriteCat z:0];

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

        self.feetPosition = CGPointMake(25.0f, 23.0f);
        self.velocity = CGPointMake(3.0f, 0.0f);
        self.acceleration = CGPointMake(0.0f, -2.0f);

        self.powerInteger      = 0;
        self.powerIntegerMax   = 3;
        self.powerDecimal      = 0;
        self.powerDecimalMax   = 5;
        self.powerDecimalDelta = 1;

        self.state = MBoyStateInvalid;

        self.highest = 0.0f;

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
-(void) setFeetPosition:(CGPoint)position
{
    if (!CGPointEqualToPoint(self->_feetPosition, position))
    {
        self->_feetPosition = position;

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

        p.y += 22.0f;

        if (self.spriteCat.visible)
        {
            self.spriteCat.position = p;
        }

        p.y += 28.0f;

        self.spritePowerBase.position = p;

        p = ccpAdd(p, v);

        self.spritePowerMask.position = p;

        //
        if (self.highest < position.y)
        {
            self.score += MScorePerMeter * (ceilf(position.y / 30.0f) - ceilf(self.highest / 30.0f));

            self.highest = position.y;
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
-(CGPoint) acceleration
{
    CGPoint a = self->_acceleration;

    if (self.boyState == MBoyStateGlide)
    {
        a.y += 1.0f;
    }

    return a;
}

//------------------------------------------------------------------------------
-(void) setState:(MBoyState)state
{
    if (self->_boyState != state)
    {
        BOOL needUpdatePowerUI = FALSE;

        if (self->_boyState == MBoyStateStrengthExtra)
        {
            needUpdatePowerUI = TRUE;

            self.powerIntegerMax -= 2;

            if (self.powerInteger > self.powerIntegerMax)
            {
                self.powerInteger = self.powerIntegerMax;
            }
        }
        else if (state == MBoyStateStrengthExtra)
        {
            needUpdatePowerUI = TRUE;

            self.powerIntegerMax += 2;

            self.spriteHat.displayFrame =
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_hat_power.png"];
        }

        if (self->_boyState == MBoyStateAgile)
        {
            self.powerDecimalDelta -= 2;
        }
        else if (state == MBoyStateAgile)
        {
            self.powerDecimalDelta += 2;

            self.spriteHat.displayFrame =
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_hat_magnet.png"];
        }

        if (state == MBoyStateDoubleJump)
        {
            self.spriteHat.displayFrame =
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_hat_double.png"];
        }
        else if (state == MBoyStateGlide)
        {
            self.spriteHat.displayFrame =
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_hat_fly.png"];
        }

        self->_boyState = state;

        if (needUpdatePowerUI)
        {
            [self updatePowerUI];
        }
    }
}

//------------------------------------------------------------------------------
-(void) setPressed:(BOOL)pressed
{
    if (self->_pressed != pressed)
    {
        self->_pressed = pressed;

        if (pressed)
        {
        }
        else
        {
            if (self.step)
            {
                if (self.step.type == MTowerObjectTypeStepDrift)
                {
                }
                else
                {
                    CGPoint v = self.velocity;

                    float s[] = {16.0f, 18.0f, 20.0f, 22.0f, 24.0f, 26.0f, 28.0f, 30.0f, 32.0f, 34.0f, 36.0f};

                    v.y = (self.powerInteger > 9) ? 36.0f : s[self.powerInteger];

                    if (self.step.type == MTowerObjectTypeStepSpring)
                    {
                        v.y += 10.0f;
                    }

                    self.step = nil;

                    self.velocity = v;

                    self.score += MScorePerJump;
                }
            }
            else if (self.boyState == MBoyStateDoubleJump)
            {
                if (!self.doubleJumped)
                {
                    self.doubleJumped = TRUE;

                    CGPoint v = self.velocity;

                    v.y = 20.0f;

                    self.velocity = v;
                }
            }
            else if (self.boyState == MBoyStateGlide)
            {
            }
        }
    }
}

//------------------------------------------------------------------------------
-(void) setStep:(MSpriteTowerStepBase*)step
{
    if (self->_step != step)
    {
        if (step)
        {
            [step boyLand:self];

            self.doubleJumped = FALSE;
        }

        if (self->_step)
        {
            [self->_step boyJump:self];
        }

        self->_step = step;
    }
}

//------------------------------------------------------------------------------
-(void) setCatState:(uint32_t)catState
{
    if (self->_catState != catState)
    {
        self->_catState = catState;

        self.spriteCat.visible = (catState != 0);
    }
}

//------------------------------------------------------------------------------
-(void) updatePower
{
    BOOL updateUI = FALSE;

    if (self.pressed)
    {
        if (self.step)
        {
            if (self.step.type == MTowerObjectTypeStepDrift)
            {
                if (self.powerInteger != 0)
                {
                    self.powerInteger = 0;

                    updateUI = TRUE;
                }
            }
            else if (self.powerInteger < self.powerIntegerMax)
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
    CGPoint p = self->_feetPosition;

    p.y += 50.0f;

    self.spritePowerBase.scaleX = 4.0f * ((float)(self.powerIntegerMax + 2) / 12.0f);

    self.spritePowerBase.position = p;

    self.spritePowerMask.scaleX = 4.0f * ((float)(self.powerInteger) / 10.0f);

    self.spritePowerMask.position = p;
}

//------------------------------------------------------------------------------
-(BOOL) collectItem:(MSpriteTowerItemBase*)item
{
    BOOL collected = TRUE;

    switch (item.type)
    {
    case MTowerObjectTypeItemBomb:
        {
            if (!self.step)
            {
                collected = FALSE;
            }
            else if (self.boyState != MBoyStateInvalid)
            {
                self.boyState = MBoyStateInvalid;
            }
            else if (self.powerIntegerMax > 3)
            {
                self.powerIntegerMax -= 1;

                if (self.powerInteger > self.powerIntegerMax)
                {
                    self.powerInteger = self.powerIntegerMax;
                }

                [self updatePowerUI];
            }
            else
            {
                collected = TRUE;
            }
        }
        break;
    case MTowerObjectTypeItemBox:
        {
            if (self.catState)
            {
                self.catState = 0;

                self.score += MScorePerCatBox;
            }
            else
            {
                collected = FALSE;
            }
        }
        break;
    case MTowerObjectTypeItemCat:
        {
            if (self.catState)
            {
                collected = FALSE;
            }
            else
            {
                self.catState = 1;

                self.score += MScorePerCat;
            }
        }
        break;
    case MTowerObjectTypeItemMilkAgile:
        {
            self.state = MBoyStateAgile;

            self.score += MScorePerFlavoredMilk;
        }
        break;
    case MTowerObjectTypeItemMilkDash:
        {
            CGPoint v = self.velocity;

            v.y = 40.0f;

            self.step = nil;

            self.velocity = v;

            self.score += MScorePerFlavoredMilk;
        }
        break;
    case MTowerObjectTypeItemMilkDoubleJump:
        {
            self.state = MBoyStateDoubleJump;

            self.score += MScorePerFlavoredMilk;
        }
        break;
    case MTowerObjectTypeItemMilkGlide:
        {
            self.state = MBoyStateGlide;

            self.score += MScorePerFlavoredMilk;
        }
        break;
    case MTowerObjectTypeItemMilkStrength:
        {
            self->_milkCount += 1;

            if (self->_milkCount >= 10)
            {
                self->_powerIntegerMax += 1;

                self->_milkCount -= 10;

                [self updatePowerUI];
            }

            self.score += MScorePerMilk;
        }
        break;
    case MTowerObjectTypeItemMilkStrengthExtra:
        {
            self.state = MBoyStateStrengthExtra;

            self.score += MScorePerFlavoredMilk;
        }
        break;
    default:
        {
            NSAssert(0, @"[MBoyLocal collectItem:]");
        }
        break;
    }

    if (collected)
    {
        [item collected];
    }

    return collected;
}

//------------------------------------------------------------------------------
@end
