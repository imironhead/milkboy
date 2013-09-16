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
@property (nonatomic, assign, readwrite) MBoyPet pet;
@property (nonatomic, assign, readwrite) MBoySuit suit;
@property (nonatomic, strong) CCSpriteBatchNode* sprite;
@property (nonatomic, strong) CCSprite* spriteBoy;
@property (nonatomic, strong) CCSprite* spritePet;
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
        self.spriteBoy = [CCSprite spriteWithSpriteFrameName:@"char_commoner_move_00.png"];

        self.spriteBoy.scale = 2.0f;
        self.spriteBoy.position = ccp(160.0f, 1.0f);
        self.spriteBoy.anchorPoint = ccp(0.5f, 0.0f);

        [self.sprite addChild:self.spriteBoy z:0];

        //--cat sprite
        self.spritePet = [CCSprite spriteWithSpriteFrameName:@"char_cat_00_lying_00.png"];

        self.spritePet.scale = 2.0f;
        self.spritePet.visible = FALSE;
        self.spritePet.position = ccp(160.0f, 240.0f);
        self.spritePet.anchorPoint = ccp(0.5f, 0.0f);

        [self.sprite addChild:self.spritePet z:0];

        //--animation frames
        [self loadDisplayFrames:@"commoner"];

        self.indexFrameBoy = 0;

        //--initial state
        self.boundCollision = CGRectMake(-11.0f, 0.0f, 22.0f, 44.0f);

        self.feetPosition = CGPointMake(25.0f, 23.0f);
        self.velocity = CGPointMake(3.0f, 0.0f);
        self.acceleration = CGPointMake(0.0f, -2.0f);

        self.powerInteger      = 0;
        self.powerIntegerMax   = 3;
        self.powerDecimal      = 0;
        self.powerDecimalMax   = MGAMECONFIG_POWER_DECIMAL_MAX;
        self.powerDecimalDelta = MGAMECONFIG_POWER_DECIMAL_DELTA;

        self.suit = MBoySuitCommoner;

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

        p.y += CGRectGetHeight(self.spriteBoy.boundingBox);

        if (self.spritePet.visible)
        {
            self.spritePet.position = p;
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
        self.spritePet.flipX = self.spriteBoy.flipX;
    }
}

//------------------------------------------------------------------------------
-(CGPoint) acceleration
{
    CGPoint a = self->_acceleration;

    if (self.suit == MBoySuitAstronaut)
    {
        a.y += 1.0f;
    }

    return a;
}

//------------------------------------------------------------------------------
-(void) setSuit:(MBoySuit)suit
{
    if (self->_suit != suit)
    {
        BOOL needUpdatePowerUI = FALSE;

        switch (self->_suit)
        {
        case MBoySuitFootballPlayer:
            {
                self.powerDecimalDelta -= 2;
            }
            break;
        case MBoySuitSuperhero:
            {
                needUpdatePowerUI = TRUE;

                self.powerIntegerMax -= 2;

                if (self.powerInteger > self.powerIntegerMax)
                {
                    self.powerInteger = self.powerIntegerMax;
                }
            }
            break;
        default:
            break;
        }

        switch (suit)
        {
        case MBoySuitAstronaut:
            [self loadDisplayFrames:@"astronaut"];
            break;
        case MBoySuitCEO:
            [self loadDisplayFrames:@"magician"];
            break;
        case MBoySuitCommoner:
            [self loadDisplayFrames:@"commoner"];
            break;
        case MBoySuitFootballPlayer:
            {
                self.powerDecimalDelta += 2;

                [self loadDisplayFrames:@"footballplayer"];
            }
            break;
        case MBoySuitNinja:
            [self loadDisplayFrames:@"ninja"];
            break;
        case MBoySuitSuperhero:
            {
                needUpdatePowerUI = TRUE;

                self.powerIntegerMax += 2;

                [self loadDisplayFrames:@"superhero"];
            }
            break;
        default:
            break;
        }

        self->_suit = suit;

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
                    else if (self.step.type == MTowerObjectTypeStepSpringChargeAuto)
                    {
                        int32_t k = [[self.step parameter] intValue];

                        v.y += (float)(2 * (k + 1));
                    }
                    else if (self.step.type == MTowerObjectTypeStepAbsorb)
                    {
                        v.y -= 4.0f;
                    }

                    self.step = nil;

                    self.velocity = v;

                    self.score += MScorePerJump;
                }
            }
            else if (self.suit == MBoySuitNinja)
            {
                if (!self.doubleJumped)
                {
                    self.doubleJumped = TRUE;

                    CGPoint v = self.velocity;

                    v.y = 20.0f;

                    self.velocity = v;
                }
            }
        }
    }
}

//------------------------------------------------------------------------------
-(void) setStep:(MSpriteTowerStep*)step
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
-(void) setPet:(MBoyPet)pet
{
    if (self->_pet != pet)
    {
        self->_pet = pet;

        if (MBoyPetNone == pet)
        {
            self.spritePet.visible = FALSE;
        }
        else
        {
            self.spritePet.visible = TRUE;

            CGPoint p = self.feetPosition;

            p.y += CGRectGetHeight(self.spriteBoy.boundingBox);

            self.spritePet.position = p;

            if (MBoyPetCat == pet)
            {
                self.spritePet.displayFrame =
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_cat_00_lying_00.png"];
            }
            else if (MBoyPetDog == pet)
            {
                self.spritePet.displayFrame =
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_dog_00_lying_00.png"];
            }
        }
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
#if MGAMECONFIG_DROP_LOST_POWER
        else
        {
            if (self.powerInteger || self.powerDecimal)
            {
                self.powerInteger = 0;
                self.powerDecimal = 0;

                updateUI = TRUE;
            }
        }
#endif
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
-(BOOL) collectItem:(MSpriteTowerItem*)item
{
    BOOL collected = TRUE;

    MTowerObjectType type;

    if (item.type == MTowerObjectTypeItemQuestionMark)
    {
        type = item.parameter;
    }
    else
    {
        type = item.type;
    }

    switch (type)
    {
    case MTowerObjectTypeItemBombBig:
        {
            CGPoint v = self.velocity;

            v.y = 40.0f;

            self.step = nil;

            self.velocity = v;

            self.score += MScorePerSuit;
        }
        break;
    case MTowerObjectTypeItemBombSmall:
        {
            CGPoint v = self.velocity;

            v.y = 20.0f;

            self.step = nil;

            self.velocity = v;

            self.score += MScorePerSuit;
        }
        break;
    case MTowerObjectTypeItemCat:
        {
            if (self.pet == MBoyPetNone)
            {
                self.pet = MBoyPetCat;

                self.score += MScorePerCat;
            }
            else
            {
                collected = FALSE;
            }
        }
        break;

    case MTowerObjectTypeItemCatBox:
        {
            if (self.pet == MBoyPetCat)
            {
                self.pet = MBoyPetNone;

                self.score += MScorePerCatBox;
            }
            else
            {
                collected = FALSE;
            }
        }
        break;
    case MTowerObjectTypeItemCoinGold:
        {}
        break;
    case MTowerObjectTypeItemCollectionMilk_00:
    case MTowerObjectTypeItemCollectionMilk_01:
    case MTowerObjectTypeItemCollectionMilk_02:
    case MTowerObjectTypeItemCollectionMilk_03:
    case MTowerObjectTypeItemCollectionMilk_04:
    case MTowerObjectTypeItemCollectionMilk_05:
        {
        }
        break;
    case MTowerObjectTypeItemDog:
        {
            if (self.pet == MBoyPetNone)
            {
                self.pet = MBoyPetDog;

                self.score += MScorePerCat;
            }
            else
            {
                collected = FALSE;
            }
        }
        break;

    case MTowerObjectTypeItemDogHouse:
        {
            if (self.pet == MBoyPetDog)
            {
                self.pet = MBoyPetNone;

                self.score += MScorePerCatBox;
            }
            else
            {
                collected = FALSE;
            }
        }
        break;
    case MTowerObjectTypeItemSuitAstronaut:
        {
            self.suit = MBoySuitAstronaut;

            self.score += MScorePerSuit;
        }
        break;
    case MTowerObjectTypeItemSuitCEO:
        {
            self.suit = MBoySuitCEO;

            self.score += MScorePerSuit;
        }
        break;
    case MTowerObjectTypeItemSuitCommoner:
        {
            self.suit = MBoySuitCommoner;

            self.score += MScorePerSuit;
        }
        break;
    case MTowerObjectTypeItemSuitFootballPlayer:
        {
            self.suit = MBoySuitFootballPlayer;

            self.score += MScorePerSuit;
        }
        break;
    case MTowerObjectTypeItemSuitNinja:
        {
            self.suit = MBoySuitNinja;

            self.score += MScorePerSuit;
        }
        break;
    case MTowerObjectTypeItemSuitSuperhero:
        {
            self.suit = MBoySuitSuperhero;

            self.score += MScorePerSuit;
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
        [item collectedWithFlag:nil];
    }

    return collected;
}

//------------------------------------------------------------------------------
-(void) loadDisplayFrames:(NSString*)category
{
    if (self.framesBoy)
    {
        [self.framesBoy removeAllObjects];
    }
    else
    {
        self.framesBoy = [NSMutableArray arrayWithCapacity:10];
    }

    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];

    NSString* name = [NSString stringWithFormat:@"char_%@_", category];

    for (uint32_t m = 0; m < 8; ++m)
    {
        [self.framesBoy addObject:
            [cache spriteFrameByName:[name stringByAppendingFormat:@"move_%02d.png", m]]];
    }

    [self.framesBoy addObject:
        [cache spriteFrameByName:[name stringByAppendingFormat:@"up_00.png"]]];

    [self.framesBoy addObject:
        [cache spriteFrameByName:[name stringByAppendingFormat:@"down_00.png"]]];

    //
    [self.spriteBoy setDisplayFrame:self.framesBoy[self.indexFrameBoy]];
}

//------------------------------------------------------------------------------
@end
