//
//  MLayerTower.m
//  Milkboy
//
//  Created by iRonhead on 7/8/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTowerBoy.h"
#import "MLayerTower.h"
#import "MLayerTowerBackground.h"
#import "MLayerTowerStages.h"
#import "MLayerTowerWall.h"
#import "MScene.h"
#import "MSpriteTowerItem.h"
#import "MSpriteTowerStage.h"
#import "MSpriteTowerStep.h"


//------------------------------------------------------------------------------
@interface MLayerTower ()
@property (nonatomic, strong) CCLayerColor* layerDarken;
@property (nonatomic, strong) CCLayer* layerCamera;
@property (nonatomic, strong) MLayerTowerBackground* layerBackground;
@property (nonatomic, strong) MLayerTowerBoy* layerBoy;
@property (nonatomic, strong) MLayerTowerStages* layerStages;
@property (nonatomic, strong) MLayerTowerWall* layerWall;

@property (nonatomic, assign) MTowerType type;
@property (nonatomic, assign) uint32_t seedLarge;
@property (nonatomic, assign) uint32_t seedSmall;
@property (nonatomic, assign) int32_t frameIndex;
@end

//------------------------------------------------------------------------------
@implementation MLayerTower
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--always init to main menu type
        self.tag = MTagLayerTower;
        self.type = MTowerTypeMenuMain;
        self.seedLarge = 1 + arc4random_uniform(65534);
        self.seedSmall = self.seedLarge;
        self.frameIndex = 0;

        //--layer darken
        self.layerDarken = [CCLayerColor layerWithColor:ccc4(0x00, 0x00, 0x00, 0x80)];

        self.layerDarken.tag = MTagLayerDarken;

        [self addChild:self.layerDarken z:MTowerLayerZDarken];

        //--layer camera
        self.layerCamera = [CCLayer new];

        self.layerCamera.tag = MTagLayerCamera;

        self.layerCamera.position = ccp(5.0f, 64.0f);

        [self addChild:self.layerCamera z:MTowerLayerZCamera];

        //--brick
        self.layerBackground = [MLayerTowerBackground new];

        [self.layerCamera addChild:self.layerBackground z:MTowerLayerZBackground];

        //--stages
        self.layerStages = [MLayerTowerStages new];

        [self.layerCamera addChild:self.layerStages z:MTowerLayerZStep];

        //--wall
        self.layerWall = [MLayerTowerWall new];

        [self.layerCamera addChild:self.layerWall z:MTowerLayerZWall];

        //--boy
        self.layerBoy = [MLayerTowerBoy new];

        [self.layerCamera addChild:self.layerBoy z:MTowerLayerZChar];

        //--
        [self scheduleUpdate];

        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:TRUE];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) dealloc
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

//------------------------------------------------------------------------------
-(void) update:(ccTime)elapsed
{
    self.frameIndex += 1;

    [self.layerStages updateToFrame:self.frameIndex];
    [self updateBoy];
    [self updateCamera];

    [self.layerBackground update];
    [self.layerWall update];
}

//------------------------------------------------------------------------------
-(void) updateBoy
{
    MLayerTowerBoy* boy = self.layerBoy;

    //--power
    [boy updatePower];

    //--adjust the velocity base on state
    CGPoint vO;
    CGPoint vB = ccp(0.0f, 0.0f);
    CGPoint vP = boy.feetPosition;
    CGPoint vV = boy.velocity;
    CGPoint aC = boy.acceleration;

    CGRect boundBoy = boy.boundCollision;

    float boundBoyMinX = vP.x + CGRectGetMinX(boundBoy);
    float boundBoyMaxX = vP.x + CGRectGetMaxX(boundBoy);

    MSpriteTowerStepBase* step = boy.step;

    if (step)
    {
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
            boy.step = nil;
        }
        else if (step.type == MTowerObjectTypeStepPatrolVertical)
        {
            vO.y += CGRectGetMaxY(boundStep) - vP.y - CGRectGetMinY(boundBoy);
        }
    }
    else
    {
        for (MSpriteTowerStage* stage in self.layerStages.stagesVisible)
        {
            step = [stage collideStepWithPosition:vP
                                         velocity:&vO
                                            bound:boundBoy
                                       frameIndex:self.frameIndex];

            if (step)
            {
                break;
            }
        }

        if (step)
        {
            boy.step = step;

            vV.y = 0.0f;

            vO.x = floorf(vO.x);
        }
    }

    //--update before collide item (may dash)
    boy.feetPosition = ccpAdd(vP, vO);
    boy.velocity = vV;

    //--collide item
    NSArray* items;

    for (MSpriteTowerStage* stage in self.layerStages.stagesVisible)
    {
        items = [stage collideItemWithPosition:vP velocity:vO bound:boundBoy];

        if (items && [items count])
        {
            for (MSpriteTowerItemBase* item in items)
            {
                [boy collectItem:item];
            }
        }
    }
}

//------------------------------------------------------------------------------
-(void) updateCamera
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        CGPoint p = self.layerBoy.feetPosition;

        if (p.y > 176.0f /*240.0f - 64.0f*/)
        {
            p.x = 5.0f;
            p.y = 240.0f - p.y;

            self.layerCamera.position = p;
        }
        else
        {
            p.x = 5.0f;
            p.y = 64.0f;

            self.layerCamera.position = p;
        }
    }
}

//------------------------------------------------------------------------------
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        self.layerBoy.pressed = TRUE;
    }

    return TRUE;
}

//------------------------------------------------------------------------------
-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        self.layerBoy.pressed = FALSE;
    }
}

//------------------------------------------------------------------------------
-(void) ccTouchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        self.layerBoy.pressed = FALSE;
    }
}

//------------------------------------------------------------------------------
-(void) transformToType:(MTowerType)type duration:(ccTime)duration
{
    [self.layerDarken runAction:[CCFadeTo actionWithDuration:duration opacity:0x00]];

    [self.layerStages transformToType:type duration:duration];

self.type = type;
}

//------------------------------------------------------------------------------
@end
