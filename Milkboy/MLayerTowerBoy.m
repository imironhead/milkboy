//
//  MLayerTowerBoy.m
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTowerBoy.h"
#import "MLayerTowerObjects.h"
#import "MNodeDictionary.h"
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
    MBoySpriteFrameJump0,
    MBoySpriteFrameDown0,
} MBoySpriteFrame;

//------------------------------------------------------------------------------
typedef enum _MBoySpriteZ
{
    MBoySpriteZShadow7 = -8,
    MBoySpriteZShadow6 = -7,
    MBoySpriteZShadow5 = -6,
    MBoySpriteZShadow4 = -5,
    MBoySpriteZShadow3 = -4,
    MBoySpriteZShadow2 = -3,
    MBoySpriteZShadow1 = -2,
    MBoySpriteZShadow0 = -1,

    MBoySpriteZBody = 0,
    MBoySpriteZPet,
    MBoySpriteZEye,
} MBoySpriteZ;

//------------------------------------------------------------------------------
@interface MLayerTowerBoy()
@property (nonatomic, assign, readwrite) CGRect boundCollision;
@property (nonatomic, assign, readwrite) uint32_t powerInteger;
@property (nonatomic, assign, readwrite) uint32_t powerIntegerMax;
@property (nonatomic, assign, readwrite) uint32_t powerDecimal;
@property (nonatomic, assign, readwrite) uint32_t powerDecimalMax;
@property (nonatomic, assign, readwrite) uint32_t powerDecimalDelta;
@property (nonatomic, assign, readwrite) uint32_t coin;
@property (nonatomic, assign, readwrite) uint32_t combo;
@property (nonatomic, assign, readwrite) uint32_t height;
@property (nonatomic, assign, readwrite) uint32_t score;
@property (nonatomic, assign, readwrite) MBoyPet pet;
@property (nonatomic, assign, readwrite) MBoySuit suit;
@property (nonatomic, strong) CCSpriteBatchNode* sprite;
@property (nonatomic, strong) CCSprite* spriteBoy;
@property (nonatomic, strong) CCSprite* spritePet;
@property (nonatomic, strong) CCSprite* spriteEye;
@property (nonatomic, strong) CCSprite* spritePowerBase;
@property (nonatomic, strong) CCSprite* spritePowerMask;
@property (nonatomic, strong) CCSprite* spriteComboBase;
@property (nonatomic, strong) CCSprite* spriteComboMask;
@property (nonatomic, strong) CCParticleBatchNode* emitters;
@property (nonatomic, strong) CCParticleSystemQuad* emitterMovement;
@property (nonatomic, strong) NSMutableArray* spritesShadow;
@property (nonatomic, strong) NSMutableArray* framesShadow;
@property (nonatomic, strong) NSMutableArray* framesMovementParticle;
@property (nonatomic, strong) NSMutableArray* framesBoy;
@property (nonatomic, strong) NSMutableArray* framesHat;
@property (nonatomic, assign) NSUInteger indexFrameBoy;
@property (nonatomic, assign) BOOL doubleJumped;
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

        [self.sprite addChild:self.spriteBoy z:MBoySpriteZBody];

        //--eye sprite
        self.spriteEye = [CCSprite spriteWithSpriteFrameName:@"char_eye.png"];

        self.spriteEye.visible = TRUE;
        self.spriteEye.anchorPoint = ccp(0.0f, 0.0f);
        self.spriteEye.position = ccp(0.0f, 0.0f);

        [self.spriteBoy addChild:self.spriteEye z:MBoySpriteZEye];

        //--pet sprite
        self.spritePet = [CCSprite spriteWithSpriteFrameName:@"char_cat_00_lying_00.png"];

        self.spritePet.visible = FALSE;
        self.spritePet.anchorPoint = ccp(0.0f, 0.0f);
        self.spritePet.position = ccp(0.0f, 0.0f);

        [self.spriteBoy addChild:self.spritePet z:MBoySpriteZPet];

        //--shadows
        self.spritesShadow = [NSMutableArray array];

        self.framesShadow = [NSMutableArray array];

        CCSpriteFrame* frameTemp =
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"char_commoner_move_00.png"];

        for (int32_t i = 0; i < 8; ++i)
        {
            CCSprite* sprite = [CCSprite spriteWithSpriteFrame:frameTemp];

            sprite.scale = 2.0f;
            sprite.visible = FALSE;
            sprite.anchorPoint = ccp(0.5f, 0.0f);
            sprite.position = self.spriteBoy.position;
            sprite.opacity = 0x80 - 16 * i;

            [self.sprite addChild:sprite z:MBoySpriteZShadow0 - i];

            [self.spritesShadow addObject:sprite];

            [self.framesShadow addObject:frameTemp];
        }

        //--animation frames
        [self changeSuit:MBoySuitCommoner];

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

        //--particle system
        CCTexture2D* textureParticle =
            [[CCTextureCache sharedTextureCache] textureForKey:@"Texture/particle.pvr.ccz"];

        self.emitters =
            [CCParticleBatchNode batchNodeWithTexture:textureParticle capacity:10];

        [self addChild:self.emitters z:1000];

        CCSpriteFrame* frameParticle =
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"particle_music_note_01.png"];

        self.emitterMovement = [CCParticleSystemQuad new];

        self.emitterMovement.duration = kCCParticleDurationInfinity;
        self.emitterMovement.emitterMode = kCCParticleModeGravity;
        self.emitterMovement.emissionRate = 4.0f;
        self.emitterMovement.life = 0.5f;
        self.emitterMovement.lifeVar = 0.1f;
        self.emitterMovement.startColor = ccc4f(1.0f, 0.9f, 0.0f, 1.0f);
//        self.emitterMovement.startColorVar = ccc4f(0.2f, 0.2f, 0.2f, 0.0f);
        self.emitterMovement.endColor = ccc4f(1.0f, 0.9f, 0.0f, 0.0f);
//        self.emitterMovement.endColorVar = ccc4f(0.0f, 0.0f, 0.0f, 0.0f);
        self.emitterMovement.radialAccel = 0.0f;
        self.emitterMovement.radialAccelVar = 0.0f;
//        self.emitterMovement.startSize = 20.0f;
//        self.emitterMovement.startSizeVar = 0.0f;
        self.emitterMovement.endSize = kCCParticleStartSizeEqualToEndSize;
        self.emitterMovement.startSpin = 0.0f;
        self.emitterMovement.startSpinVar = 0.0f;
//        self.emitterMovement.speed = 0.0f;
//        self.emitterMovement.speedVar = 0.0f;
        self.emitterMovement.gravity = ccp(0.0f, 70.0f);
        self.emitterMovement.position = self.spriteBoy.position;
        self.emitterMovement.positionType = kCCPositionTypeRelative;
        self.emitterMovement.angle = 45.0f;
        self.emitterMovement.angleVar = 10.0f;

        [self.emitterMovement setDisplayFrame:frameParticle];

        [self.emitters addChild:self.emitterMovement];

        //--power ui
        self.spritePowerBase = [CCSprite spriteWithSpriteFrameName:@"char_power_back.png"];
        self.spritePowerMask = [CCSprite spriteWithSpriteFrameName:@"char_power_mark.png"];

        self.spritePowerBase.scaleY = 2.0f;
        self.spritePowerMask.scaleY = 2.0f;

        [self.sprite addChild:self.spritePowerBase z:10];
        [self.sprite addChild:self.spritePowerMask z:11];

        [self updatePowerUI];

        //--combo ui
        self.spriteComboBase = [CCSprite spriteWithSpriteFrameName:@"char_power_back.png"];
        self.spriteComboMask = [CCSprite spriteWithSpriteFrameName:@"char_power_mark.png"];

        self.spriteComboBase.scaleY = 2.0f;
        self.spriteComboMask.scaleY = 2.0f;

        [self.sprite addChild:self.spriteComboBase z:10];
        [self.sprite addChild:self.spriteComboMask z:11];

        [self updateComboUI];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) setFeetPosition:(CGPoint)position
{
    if (!CGPointEqualToPoint(self->_feetPosition, position))
    {
        //-update shadow of ninja
        for (int32_t i = self.spritesShadow.count - 1; i > 0; --i)
        {
            CCSprite* spriteNext = self.spritesShadow[i];
            CCSprite* spritePrev = self.spritesShadow[i - 1];

            if (spritePrev.visible)
            {
                spriteNext.visible = TRUE;
                spriteNext.displayFrame = self.framesShadow[self.framesShadow.count - i];
                spriteNext.position = spritePrev.position;
                spriteNext.flipX = spritePrev.flipX;
            }
            else
            {
                spriteNext.visible = FALSE;
            }
        }

        CCSprite* spriteShadow = self.spritesShadow[0];

        if (MBoySuitNinja == self.suit)
        {
            spriteShadow.visible = TRUE;
            spriteShadow.displayFrame = self.framesShadow.lastObject;
            spriteShadow.position = self.spriteBoy.position;
            spriteShadow.flipX = self.spriteBoy.flipX;
        }
        else
        {
            spriteShadow.visible = FALSE;
        }

        //
        self->_feetPosition = position;

        self.spriteBoy.position = position;

        CGPoint velocity = self->_velocity;

        if (velocity.y > 0.0f)
        {
            if (self.indexFrameBoy != MBoySpriteFrameJump0)
            {
                self.indexFrameBoy = MBoySpriteFrameJump0;

                [self.spriteBoy setDisplayFrame:self.framesBoy[MBoySpriteFrameJump0]];
            }
        }
        else if (velocity.y < 0.0f)
        {
            if (self.indexFrameBoy != MBoySpriteFrameDown0)
            {
                self.indexFrameBoy = MBoySpriteFrameDown0;

                [self.spriteBoy setDisplayFrame:self.framesBoy[MBoySpriteFrameDown0]];
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

        [self.framesShadow removeObjectAtIndex:0];
        [self.framesShadow addObject:self.framesBoy[self.indexFrameBoy]];

        //
        self.emitterMovement.position = ccpAdd(position, ccp(0.0f, 30.0f));

        //
        CGPoint v = ccpSub(self.spritePowerMask.position, self.spritePowerBase.position);

        CGPoint p = position;

        p.y += CGRectGetHeight(self.spriteBoy.boundingBox);

        p.y += 28.0f;

        self.spritePowerBase.position = p;

        p = ccpAdd(p, v);

        self.spritePowerMask.position = p;

        //
        v = ccpSub(self.spriteComboMask.position, self.spriteComboBase.position);

        p.y += 14.0f;

        self.spriteComboBase.position = p;

        p = ccpAdd(p, v);

        self.spriteComboMask.position = p;

        //
        uint32_t h;

        if (position.y > MGAMECONFIG_TOWER_PADDING_RISE)
        {
            h = (uint32_t)(position.y - MGAMECONFIG_TOWER_PADDING_RISE);
        }
        else
        {
            h = (uint32_t)position.y;
        }

        if (self.height < h)
        {
            self.score += MScorePerMeter * (h - self.height);

            self.height = h;
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
        self.spriteEye.flipX = self.spriteBoy.flipX;
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
        case MBoySuitJetpack:
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

        [self changeSuit:suit];

        switch (suit)
        {
        case MBoySuitJetpack:
            {
                self.powerDecimalDelta += 2;
            }
            break;
        case MBoySuitSuperhero:
            {
                needUpdatePowerUI = TRUE;

                self.powerIntegerMax += 2;
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
-(void) setCoin:(uint32_t)coin
{
    if (self->_coin != coin)
    {
        self->_coin = coin;

        NSNumber* noCoin = [NSNumber numberWithUnsignedInt:coin];

        MNodeDictionary* node = [MNodeDictionary nodeWithTag:MTagGameUpdateHeader info:@{@"coin": noCoin}];

        id target = [[CCDirector sharedDirector] runningScene];

        [target performSelector:@selector(onEvent:) withObject:node];
    }
}

//------------------------------------------------------------------------------
-(void) setHeight:(uint32_t)height
{
    if (self->_height != height)
    {
        self->_height = height;

        NSNumber* noHeight = [NSNumber numberWithUnsignedInt:height];

        MNodeDictionary* node = [MNodeDictionary nodeWithTag:MTagGameUpdateHeader info:@{@"height": noHeight}];

        id target = [[CCDirector sharedDirector] runningScene];

        [target performSelector:@selector(onEvent:) withObject:node];
    }
}

//------------------------------------------------------------------------------
-(void) setScore:(uint32_t)score
{
    if (self->_score != score)
    {
        self->_score = score;

        NSNumber* noScore = [NSNumber numberWithUnsignedInt:score];

        MNodeDictionary* node = [MNodeDictionary nodeWithTag:MTagGameUpdateHeader info:@{@"score": noScore}];

        id target = [[CCDirector sharedDirector] runningScene];

        [target performSelector:@selector(onEvent:) withObject:node];
    }
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
        {
            self.coin += 1;

            self.combo = MIN(MGAMECONFIG_COMBO_POINT_MAX, self.combo + MGAMECONFIG_COMBO_POINT_INCREASE_PER_COIN);

            [self updateComboUI];
        }
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
    case MTowerObjectTypeItemSuitJetpack:
        {
            self.suit = MBoySuitJetpack;

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
-(void) reset
{
    self.pet = MBoyPetNone;
    self.suit = MBoySuitCommoner;

    self.coin = 0;
    self.combo = 0;
    self.height = self.feetPosition.y;
    self.score = 0;

    [self updateComboUI];
    [self updatePowerUI];
}

//------------------------------------------------------------------------------
-(void) updateEyeWithFrame:(int32_t)frame
{
    if (self.suit == MBoySuitJetpack)
    {
        self.spriteEye.visible = FALSE;
    }
    else
    {
        self.spriteEye.visible = TRUE;

        int32_t i = frame % 60;

        GLubyte opacity = 0xff;

        switch (i)
        {
        case 8:     opacity = 0x40;     break;
        case 9:     opacity = 0x60;     break;
        case 10:    opacity = 0x80;     break;
        case 11:    opacity = 0x60;     break;
        case 12:    opacity = 0x40;     break;

        case 28:    opacity = 0x40;     break;
        case 29:    opacity = 0x60;     break;
        case 30:    opacity = 0x80;     break;
        case 31:    opacity = 0x60;     break;
        case 32:    opacity = 0x40;     break;
        }

        self.spriteEye.opacity = opacity;
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
-(void) updateWithObjects:(MLayerTowerObjects*)objects
             inTransition:(BOOL)inTransition
                    frame:(int32_t)frame
{
    [self updateEyeWithFrame:frame];

    if (inTransition && self.step && (self.step.type != MTowerObjectTypeStepBasement))
    {
        //--drop to 1st floor during transition

        self.step = nil;
    }

    //--combo
    if (self.combo > MGAMECONFIG_COMBO_POINT_DECREASE_PER_FRAME)
    {
        self.combo -= MGAMECONFIG_COMBO_POINT_DECREASE_PER_FRAME;

        [self updateComboUI];
    }

    //--power
    [self updatePower];

    //--adjust the velocity base on state
    CGPoint vO;
    CGPoint vB = ccp(0.0f, 0.0f);
    CGPoint vP = self.feetPosition;
    CGPoint vV = self.velocity;
    CGPoint aC = self.acceleration;

    CGRect boundBoy = self.boundCollision;

    float boundBoyMinX = vP.x + CGRectGetMinX(boundBoy);
    float boundBoyMaxX = vP.x + CGRectGetMaxX(boundBoy);

    MSpriteTowerStep* step = self.step;

    if (step)
    {
        //--adjust velocity base on step
        switch (step.type)
        {
        case MTowerObjectTypeStepMovingWalkwayLeft:
            {
                vB.x = -1.0f;
            }
            break;
        case MTowerObjectTypeStepMovingWalkwayRight:
            {
                vB.x = 1.0f;
            }
            break;
        case MTowerObjectTypeStepDrift:
            {
                vB.x = (vV.x > 0.0f) ? 1.0f : -1.0f;
            }
            break;
        default:
            break;
        }
    }

    //--accelerate
    vV.x += aC.x;

    if (step)
    {
        vV.y = 0.0f;
    }
    else
    {
        vV.y += aC.y;
    }

    //--collide wall
    float wallL = 0.0f;
    float wallR = 310.0f;

    if (boundBoyMinX + vV.x + vB.x < wallL)
    {
        vO.x = wallL + wallL - boundBoyMinX - boundBoyMinX - vB.x - vV.x;
        vO.y = vV.y;

        vV = CGPointMake(-vV.x, vV.y);
    }
    else if (boundBoyMaxX + vV.x + vB.x > wallR)
    {
        vO.x = wallR + wallR - boundBoyMaxX - boundBoyMaxX - vB.x - vV.x;
        vO.y = vV.y;

        vV = CGPointMake(-vV.x, vV.y);
    }
    else
    {
        vO = vV;

        vO.x += vB.x;
    }

    //--
    if (step)
    {
        //--collide the step
        CGRect boundStep = step.boundingBox;

        if ((!step.live) ||
            (boundBoyMinX > CGRectGetMaxX(boundStep)) ||
            (boundBoyMaxX < CGRectGetMinX(boundStep)))
        {
            self.step = nil;
        }
        else if (step.type == MTowerObjectTypeStepPatrolVertical)
        {
            vO.y += CGRectGetMaxY(boundStep) - vP.y - CGRectGetMinY(boundBoy);
        }
    }
    else
    {
        CGPoint vT = vO;

        step = [objects collideStepWithPosition:vP
                                       velocity:&vO
                                          bound:boundBoy
                                     frameIndex:frame];

        if (step)
        {
            if (inTransition)
            {
                if (step.type == MTowerObjectTypeStepBasement)
                {
                    self.step = step;

                    vV.y = 0.0f;

                    vO.x = floorf(vO.x);
                }
                else
                {
                    vO = vT;
                }
            }
            else
            {
                self.step = step;

                vV.y = 0.0f;

                vO.x = floorf(vO.x);
            }
        }
    }

    //--update before collide item (may dash)
    self.feetPosition = ccpAdd(vP, vO);
    self.velocity = vV;

    //--collide item
    if (inTransition)
    {
        //--collide nothin during transition
    }
    else
    {
        NSArray* items = [objects collideItemWithPosition:vP velocity:vO bound:boundBoy];

        if (items && [items count])
        {
            for (MSpriteTowerItem* item in items)
            {
                [self collectItem:item];
            }
        }
    }
}

//------------------------------------------------------------------------------
-(void) updatePowerUI
{
    self.spritePowerBase.scaleX = 4.0f * ((float)(self.powerIntegerMax + 2) / 12.0f);

    self.spritePowerMask.scaleX = 4.0f * ((float)(self.powerInteger) / 10.0f);
}

//------------------------------------------------------------------------------
-(void) updateComboUI
{
    float c =
        (self.combo >= MGAMECONFIG_COMBO_POINT_THRESHOLD) ?
        (MGAMECONFIG_COMBO_POINT_THRESHOLD / MGAMECONFIG_COMBO_POINT_DIVISOR) :
        (self.combo / MGAMECONFIG_COMBO_POINT_DIVISOR);

    self.spriteComboBase.scaleX = 4.0f * ((float)(5 + 2) / 12.0f);

    self.spriteComboMask.scaleX = 4.0f * (c / 10.0f);
}

//------------------------------------------------------------------------------
-(void) changeSuit:(MBoySuit)suit
{
    if (self.framesBoy)
    {
        [self.framesBoy removeAllObjects];
    }
    else
    {
        self.framesBoy = [NSMutableArray arrayWithCapacity:10];
    }

    NSString* category;

    switch (suit)
    {
    case MBoySuitAstronaut :
        category = @"astronaut";
        break;
    case MBoySuitCEO:
        category = @"ceo";
        break;
    case MBoySuitJetpack:
        category = @"jetpack";
        break;
    case MBoySuitNinja:
        category = @"ninja";
        break;
    case MBoySuitSuperhero:
        category = @"superhero";
        break;
    case MBoySuitCommoner:
    default:
        category = @"commoner";
        break;
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

    //
    self.framesShadow[self.framesShadow.count - 1] =
        self.framesBoy[self.indexFrameBoy];

    //--suit effect
}

//------------------------------------------------------------------------------
@end
