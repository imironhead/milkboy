//
//  MLayerTower.m
//  Milkboy
//
//  Created by iRonhead on 7/8/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MBoy.h"
#import "MLayerTower.h"
#import "MScene.h"
#import "MTowerItem.h"
#import "MTowerStage.h"
#import "MTowerStep.h"
#import "MWall.h"


//------------------------------------------------------------------------------
@interface MLayerTower ()
@property (nonatomic, strong) MBoy* boy;
@property (nonatomic, strong) MWall* wall;
@property (nonatomic, strong) CCSpriteBatchNode* batchNodeSteps;
@property (nonatomic, strong) NSMutableArray* stagesInTower;
@property (nonatomic, strong) NSMutableArray* stagesVisible;

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

        //--boy
        self.boy = [MBoy new];

        [self addChild:self.boy.sprite z:MTowerSpriteDepthChar];

        //--wall
        self.wall = [MWall new];

        [self addChild:self.wall.spritesBack z:MTowerSpriteDepthBack];
        [self addChild:self.wall.spritesWall z:MTowerSpriteDepthWall];

        //--batch node for steps & items
        self.batchNodeSteps = [CCSpriteBatchNode batchNodeWithFile:@"Texture/step.pvr.ccz" capacity:32];

        [self addChild:self.batchNodeSteps z:MTowerSpriteDepthStep];

        //--basement
        MTowerStage* stage = [MTowerStage basementStage];

        self.stagesInTower = [NSMutableArray arrayWithObject:stage];
        self.stagesVisible = [NSMutableArray arrayWithObject:stage];

        //--first stage for main menu
        stage = [MTowerStage menuMainStage];

        [self.stagesInTower addObject:stage];
        [self.stagesVisible addObject:stage];

        //--add sprites of steps & items
        for (stage in self.stagesVisible)
        {
            for (MTowerStepBase* step in stage.steps)
            {
                [self.batchNodeSteps addChild:step.sprite z:0];
            }

            for (MTowerItemBase* item in stage.items)
            {
                [self.batchNodeSteps addChild:item.sprite z:1];
            }
        }

        //--darken layer
        CCLayerColor* layerDarken = [CCLayerColor layerWithColor:ccc4(0x00, 0x00, 0x00, 0x80)];

        layerDarken.tag = MTagLayerDarken;

        layerDarken.position = ccp(-5.0f, -64.0f);

        [self addChild:layerDarken z:MTowerSpriteDepthDarken];

        //--update camera for main menu
        self.position = ccp(5.0f, 64.0f);

        self.wall.cameraPosition = ccp(0.0f, 176.0f);

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
//    [self updateBoyForMainMenu];

    [self updateStage];
    [self updateBoy];
    [self updateCamera];
}

//------------------------------------------------------------------------------
-(void) updateBoy
{
    MBoy* boy = self.boy;

    //--power
    [boy updatePower];

    //--adjust the velocity base on state
    CGPoint vO;
    CGPoint vB = CGPointMake(0.0f, 0.0f);
    CGPoint vP = boy.position;
    CGPoint vV = boy.velocity;
    CGPoint aC = boy.acceleration;

    CGRect boundBoy = boy.boundCollision;

    float boundBoyMinX = vP.x + CGRectGetMinX(boundBoy);
    float boundBoyMaxX = vP.x + CGRectGetMaxX(boundBoy);

    MTowerStepBase* step = boy.step;

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
        CGRect boundStep = step.boundCollision;

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
        for (MTowerStage* stage in self.stagesVisible)
        {
            step = [stage collideStepWithPosition:vP velocity:&vO bound:boundBoy];

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
    boy.position = ccpAdd(vP, vO);
    boy.velocity = vV;

    //--collide item
    NSArray* items;

    for (MTowerStage* stage in self.stagesVisible)
    {
        items = [stage collideItemWithPosition:vP velocity:vO bound:boundBoy];

        if (items && [items count])
        {
            for (MTowerItemBase* item in items)
            {
                [boy collectItem:item];
            }
        }
    }
}

//------------------------------------------------------------------------------
-(void) updateStage
{
    if (self.type != MTowerTypeGameSinglePlayer)
    {
        return;
    }

    CGPoint p = self.boy.position;

    //--check upper bound only

    MTowerStage* stage = [self.stagesInTower lastObject];

    if (p.y + 512.0f > stage.rangeCollision.lowerBound)
    {
        stage = [MTowerStage stageWithIndex:stage.stageIndex + 1
                                       seed:self.seedLarge];

        [self.stagesInTower addObject:stage];
    }

    //--check lower bound only

    //--check visibility
    MTowerStage* stageU = [self.stagesVisible lastObject];
    MTowerStage* stageB = [self.stagesVisible objectAtIndex:0];

    if ((stageU.rangeCollision.lowerBound < p.y) ||
        (stageB.rangeCollision.upperBound > p.y))
    {
        MVisibilityRange range;

        MTowerStage* stage;

        for (stage in self.stagesInTower)
        {
            range = stage.rangeCollision;

            if ((range.lowerBound > p.y) || (range.upperBound < p.y))
            {
                continue;
            }

            break;
        }

        uint32_t idxL = (stage.stageIndex > 0) ? (stage.stageIndex - 1) : 0;
        uint32_t idxU = idxL + 2;

        MTowerItemBase* item;
        MTowerStepBase* step;

        //--remove sprites
        [self.batchNodeSteps removeAllChildrenWithCleanup:NO];

        [self.stagesVisible removeAllObjects];

        for (stage in self.stagesInTower)
        {
            if (idxL > stage.stageIndex)
            {
                continue;
            }

            if (idxU < stage.stageIndex)
            {
                break;
            }

            for (step in stage.steps)
            {
                [self.batchNodeSteps addChild:step.sprite z:0];
            }

            for (item in stage.items)
            {
                [self.batchNodeSteps addChild:item.sprite z:1];
            }

            [self.stagesVisible addObject:stage];
        }
    }

    //--update visible stage
    self.frameIndex += 1;

    for (stage in self.stagesVisible)
    {
        [stage jumpToFrame:self.frameIndex refresh:TRUE];
    }
}

//------------------------------------------------------------------------------
-(void) updateCamera
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        CGPoint p = self.boy.position;

        self.wall.cameraPosition = p;

        p.x = 5.0f;
        p.y = 240.0f - p.y;

        self.position = p;
    }
}

//------------------------------------------------------------------------------
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        self.boy.pressed = TRUE;
    }

    return TRUE;
}

//------------------------------------------------------------------------------
-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        self.boy.pressed = FALSE;
    }
}

//------------------------------------------------------------------------------
-(void) ccTouchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (self.type == MTowerTypeGameSinglePlayer)
    {
        self.boy.pressed = FALSE;
    }
}

//------------------------------------------------------------------------------
-(void) transformToType:(MTowerType)type duration:(ccTime)duration
{
    CCLayerColor* layerDarken = (CCLayerColor*)[self getChildByTag:MTagLayerDarken];

    [layerDarken runAction:[CCFadeTo actionWithDuration:duration opacity:0x00]];

    //
    MTowerStage* stageBasement = self.stagesInTower[0];
    MTowerStage* stage1stFloor = (self.stagesInTower.count > 1) ? self.stagesInTower[1] : nil;

    [self.stagesInTower removeAllObjects];
    [self.stagesVisible removeAllObjects];

    [self.stagesInTower addObject:stageBasement];
    [self.stagesVisible addObject:stageBasement];

    [self.batchNodeSteps removeAllChildrenWithCleanup:NO];

    for (MTowerStepBase* step in stageBasement.steps)
    {
        [self.batchNodeSteps addChild:step.sprite z:0];
    }

    //--new stage
    MTowerStage* stageNew = [MTowerStage stageWithIndex:1 seed:0];

    [self.stagesInTower addObject:stageNew];
    [self.stagesVisible addObject:stageNew];

    for (MTowerStepBase* step in stageNew.steps)
    {
        [self.batchNodeSteps addChild:step.sprite z:0];
    }

    for (MTowerItemBase* item in stageNew.items)
    {
        [self.batchNodeSteps addChild:item.sprite z:1];
    }

    //--move all items and steps from 1st stage
    for (MTowerStepBase* step in stage1stFloor.steps)
    {
        CGPoint pos = step.sprite.position;

        pos.y = 480.0f;

        [step.sprite runAction:[CCMoveTo actionWithDuration:duration position:pos]];

        [self.batchNodeSteps addChild:step.sprite z:0];
    }

    for (MTowerItemBase* item in stage1stFloor.items)
    {
        [self.batchNodeSteps addChild:item.sprite z:1];
    }

    CCDelayTime* actionDelay = [CCDelayTime actionWithDuration:duration];

    CCCallBlock* actionFinal = [CCCallBlock actionWithBlock:^{
        for (MTowerStepBase* step in stage1stFloor.steps)
        {
            [step.sprite stopAllActions];

            [self.batchNodeSteps removeChild:step.sprite cleanup:YES];
        }

        self.type = type;
    }];

    CCSequence* actionSequence = [CCSequence actions:actionDelay, actionFinal, nil];

    [self runAction:actionSequence];
}

//------------------------------------------------------------------------------
@end
