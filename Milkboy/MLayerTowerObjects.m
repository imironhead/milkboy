//
//  MLayerTowerObjects.m
//  Milkboy
//
//  Created by iRonhead on 7/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MGame.h"
#import "MLayerTowerObjects.h"
#import "UMath.h"


//------------------------------------------------------------------------------
@interface MLayerTowerObjects ()
@property (nonatomic, assign, readwrite) float deadLine;
@property (nonatomic, strong) NSMutableArray* itemCollection;
@property (nonatomic, strong) NSMutableArray* stepCollection;
@property (nonatomic, strong) CCSpriteBatchNode* sprites;
@property (nonatomic, strong) URandomIntegerGeneratorMWC* randomStepVariance;
@property (nonatomic, strong) UAverageRandomIntegerGeneratorMWC* randomStepColumn;
@property (nonatomic, assign) float upperBound;
@end

//------------------------------------------------------------------------------
@implementation MLayerTowerObjects
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.deadLine = 0.0f;
        self.upperBound = 0.0f;
        self.canClimb = TRUE;
        self.padding = 0.0f;

        self.itemCollection = [NSMutableArray array];
        self.stepCollection = [NSMutableArray array];

        //--batch nodes
        self.sprites = [CCSpriteBatchNode batchNodeWithFile:@"Texture/step.pvr.ccz"];

        [self addChild:self.sprites];

        //--basement, the only one step which is not inside the batch node
        MSpriteTowerStepBase* step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepBasement
                                                               position:CGPointMake(160.0f, 0.0f)
                                                                   usid:(MTowerObjectGroupStep << 31)
                                                                   seed:0];

        [self.stepCollection addObject:step];

        //
        [self transformToType:MTowerTypeMenuMain];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) setPadding:(float)padding
{
    if (self->_padding != padding)
    {
        CGPoint pt;

        float d = padding - self->_padding;

        for (CCSprite* sprite in self.sprites.children)
        {
            pt = sprite.position;

            pt.y += d;

            sprite.position = pt;
        }

        self.deadLine += d;

        self.upperBound += d;

        self->_padding = padding;
    }
}

//------------------------------------------------------------------------------
-(void) setUpperBound:(float)upperBound
{
    NSAssert(floorf(upperBound) == upperBound, @"[MLayerTowerObjects setUpperBound:] accept integer only");

    self->_upperBound = upperBound;
}

//------------------------------------------------------------------------------
-(NSArray*) items
{
    return self->_itemCollection;
}

//------------------------------------------------------------------------------
-(NSArray*) steps
{
    return self->_stepCollection;
}

//------------------------------------------------------------------------------
-(NSArray*) collideItemWithPosition:(CGPoint)positionOld
                           velocity:(CGPoint)velocity
                              bound:(CGRect)bound
{
    CGPoint positionNew = ccpAdd(positionOld, velocity);

    NSMutableArray* items = nil;

    float boundBoyMinY = CGRectGetMinY(bound);
    float boundBoyMaxY = CGRectGetMaxY(bound);

    if (self.canClimb)
    {
        items = [NSMutableArray array];

        CGRect boundItem;

        float boundXMin;
        float boundXMax;
        float boundYMin;
        float boundYMax;

        CGPoint pUpper;
        CGPoint pLower;
        CGPoint pLeft;
        CGPoint pRight;

        float boundBoyMinX = CGRectGetMinX(bound);
        float boundBoyMaxX = CGRectGetMaxX(bound);

        if (velocity.x > 0.0f)
        {
            pRight = positionNew;
            pLeft  = positionOld;
        }
        else
        {
            pRight = positionOld;
            pLeft  = positionNew;
        }

        if (velocity.y > 0.0f)
        {
            pUpper = positionNew;
            pLower = positionOld;
        }
        else
        {
            pUpper = positionOld;
            pLower = positionNew;
        }

        for (MSpriteTowerItemBase* item in self.items)
        {
            if (!item.live)
            {
                continue;
            }

            boundItem = item.boundingBox;

            boundYMax = CGRectGetMaxY(boundItem) - boundBoyMinY;
            boundYMin = CGRectGetMinY(boundItem) - boundBoyMaxY;

            if ((pUpper.y < boundYMin) || (pLower.y > boundYMax))
            {
                continue;
            }

            boundXMax = CGRectGetMaxX(boundItem) - boundBoyMinX;
            boundXMin = CGRectGetMinX(boundItem) - boundBoyMaxX;

            if ((pLeft.x > boundXMax) || (pRight.x < boundXMin))
            {
                continue;
            }

            if (velocity.y == 0.0f)
            {
                [items addObject:item];

                continue;
            }

            if (pLeft.x >= boundXMin)
            {
                if (pLeft.y > boundYMax)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundXMin, boundYMax),
                        CGPointMake(boundXMax, boundYMax)))
                    {
                        [items addObject:item];
                    }
                }
                else if (pLeft.y < boundYMin)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundXMin, boundYMin),
                        CGPointMake(boundXMax, boundYMin)))
                    {
                        [items addObject:item];
                    }
                }
                else
                {
                    [items addObject:item];
                }
            }
            else
            {
                if (ccpSegmentIntersect(
                    pLeft,
                    pRight,
                    CGPointMake(boundXMin, boundYMin),
                    CGPointMake(boundXMin, boundYMax)))
                {
                    [items addObject:item];
                }
                else if (pLeft.y > boundYMax)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundXMin, boundYMax),
                        CGPointMake(boundXMax, boundYMax)))
                    {
                        [items addObject:item];
                    }
                }
                else if (pLeft.y < boundYMin)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundXMin, boundYMin),
                        CGPointMake(boundXMax, boundYMin)))
                    {
                        [items addObject:item];
                    }
                }
            }
        }
    }

    return items;
}

//------------------------------------------------------------------------------
-(MSpriteTowerStepBase*) collideStepWithPosition:(CGPoint)positionOld
                                        velocity:(CGPoint*)velocity
                                           bound:(CGRect)bound
                                      frameIndex:(int32_t)frameIndex
{
    //--collide with upper edge of bounding rect of steps
    MSpriteTowerStepBase* step = nil;

    if (!self.canClimb)
    {
    }
    else if (velocity->y >= 0.0f)
    {
        //--collide during dropping

        step = nil;
    }
    else
    {
        CGPoint positionNew = ccpAdd(positionOld, *velocity);

        float boundBoyMinY = CGRectGetMinY(bound);
        float boundBoyMinX = CGRectGetMinX(bound);
        float boundBoyMaxX = CGRectGetMaxX(bound);

        //--collide
        CGRect boundStep;

        float boundStepMinX;
        float boundStepMaxX;
        float boundStepMaxY;
        float boundStepMinY;

        for (MSpriteTowerStepBase* stepT in self.steps)
        {
            if (!stepT.live)
            {
                continue;
            }

            boundStep = stepT.boundingBox;

            boundStepMinX = CGRectGetMinX(boundStep) - boundBoyMaxX;
            boundStepMaxX = CGRectGetMaxX(boundStep) - boundBoyMinX;

            if ((positionNew.x < boundStepMinX) || (positionNew.x > boundStepMaxX))
            {
                continue;
            }

            boundStepMaxY = CGRectGetMaxY(boundStep) - boundBoyMinY;

            if (stepT.type == MTowerObjectTypeStepPatrolVertical)
            {
                [stepT updateToFrame:frameIndex - 1];

                boundStepMinY = CGRectGetMaxY(stepT.boundingBox) - boundBoyMinY;

                [stepT updateToFrame:frameIndex];

                if ((positionOld.y >= boundStepMinY) && (positionNew.y <= boundStepMaxY))
                {
                    step = stepT;

                    positionNew.y = boundStepMaxY;
                }
            }
            else
            {
                if ((positionOld.y >= boundStepMaxY) && (positionNew.y <= boundStepMaxY))
                {
                    step = stepT;

                    positionNew.y = boundStepMaxY;
                }
            }

            if (step)
            {
                *velocity = ccpSub(positionNew, positionOld);
            }
        }
    }

    return step;
}

//------------------------------------------------------------------------------
-(void) updateDeadLine
{
    //--update dead line
    float deadLineT = -self.parent.position.y;

    if (self.deadLine < deadLineT)
    {
        self.deadLine = deadLineT;

        //--remove objects those under deadline
        float y;

        NSMutableArray* dead = [NSMutableArray array];

        for (CCSprite* sprite in self.stepCollection)
        {
            y = sprite.position.y;

            if ((y < deadLineT) && (y > 0.0f))
            {
                //--remove objects that under the deadline, except the basement
                [dead addObject:sprite];

                [self.sprites removeChild:sprite cleanup:YES];
            }
        }

        [self.stepCollection removeObjectsInArray:dead];

        [dead removeAllObjects];

        for (CCSprite* sprite in self.itemCollection)
        {
            if (sprite.position.y < deadLineT)
            {
                [dead addObject:sprite];

                [self.sprites removeChild:sprite cleanup:YES];
            }
        }

        [self.itemCollection removeObjectsInArray:dead];
    }

    //--add object to rise upper bound
    [self raiseUpperBoundOfGameTower];
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    for (MSpriteTowerStepBase* step in self.steps)
    {
        [step updateToFrame:frame];
    }

    for (MSpriteTowerItemBase* item in self.items)
    {
        [item updateToFrame:frame];
    }
}

//------------------------------------------------------------------------------
-(void) transformToType:(MTowerType)type
{
    //--move all visible steps & items up
    CGPoint pt;

    for (CCSprite* sprite in self.sprites.children)
    {
        pt = sprite.position;

        if (pt.y < 600.0f)
        {
            pt.y = 600.0f;

            [sprite runAction:[CCMoveTo actionWithDuration:0.5f position:pt]];
        }
    }

    //--
    CCDelayTime* actionDelay = [CCDelayTime actionWithDuration:0.5f];

    CCCallBlock* actionBlock = [CCCallBlock actionWithBlock:
    ^{
        [self buildTowerWithType:type];

        CGPoint pt;

        for (CCSprite* sprite in self.sprites.children)
        {
            pt = sprite.position;

            if (pt.y < 600.0f)
            {
                sprite.position = ccp(pt.x, 600.0f);

                [sprite runAction:[CCMoveTo actionWithDuration:0.5f position:pt]];
            }
        }
    }];

    [self runAction:[CCSequence actions:actionDelay, actionBlock, nil]];
}

//------------------------------------------------------------------------------
-(void) buildTowerWithType:(MTowerType)type
{
    switch (type)
    {
    case MTowerTypeMenuMain:
        [self buildRegularTower];
        break;
    case MTowerTypeGameSinglePlayer:
        [self buildGameTower];
        break;
    case MTowerTypeTransition:
        NSAssert(0, @"[MLayerTowerObjects buildTowerWithType:]");
        break;
    }
}

//------------------------------------------------------------------------------
-(void) buildCleanTower
{
    [self.sprites removeAllChildrenWithCleanup:YES];

    id basement = self.stepCollection[0];

    [self.stepCollection removeAllObjects];
    [self.itemCollection removeAllObjects];

    [self.stepCollection addObject:basement];

    self.upperBound = 30.0f;
    self.deadLine = 0.0f;
    self.padding = 0.0f;
}

//------------------------------------------------------------------------------
-(void) buildRegularTower
{
    MSpriteTowerStepBase* step;
    MSpriteTowerItemBase* item;

    [self buildCleanTower];

    //
    step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                                     position:ccp(40.0f, 200.0f)
                                         usid:0
                                         seed:0];

    [self.stepCollection addObject:step];

    [self.sprites addChild:step z:1];

    //
    step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                                     position:ccp(260.0f, 280.0f)
                                         usid:0
                                         seed:0];

    [self.stepCollection addObject:step];

    [self.sprites addChild:step z:1];

    //
    step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                                     position:ccp(160.0f, 40.0f)
                                         usid:0
                                         seed:0];

    [self.stepCollection addObject:step];

    [self.sprites addChild:step z:1];

    //
    item = [MSpriteTowerItemBase itemWithType:MTowerObjectTypeItemCat
                               position:ccp(270.0f, 280.0f)
                                   uiid:0
                                   seed:0];

    [self.itemCollection addObject:item];

    [self.sprites addChild:item z:0];

    //
    item = [MSpriteTowerItemBase itemWithType:MTowerObjectTypeItemMilkStrength
                               position:ccp(60.0f, 200.0f)
                                   uiid:0
                                   seed:0];

    [self.itemCollection addObject:item];

    [self.sprites addChild:item z:0];
}

//------------------------------------------------------------------------------
-(void) buildGameTower
{
    [self buildCleanTower];

    [self raiseUpperBoundOfGameTower];
}

//------------------------------------------------------------------------------
-(void) raiseUpperBoundOfGameTower
{
    //
    const float stepInterval       = 30.0f;
    const float stepColumnWidth    = 72.0f;
    const float stepColumnVariance = 16.0f;

    //
    if (!self.randomStepVariance)
    {
        self.randomStepVariance = [URandomIntegerGeneratorMWC
            randomIntegerGeneratorWithRange:URandomIntegerRangeMake(0, (int32_t)stepColumnVariance)
                                      seedA:3
                                      seedB:4];
    }

    if (!self.randomStepColumn)
    {
        self.randomStepColumn = [UAverageRandomIntegerGeneratorMWC
            averageRandomIntegerGeneratorWithRange:URandomIntegerRangeMake(0, 3)
                                             seedA:1
                                             seedB:2];
    }

    CGPoint pos = self.parent.position;

    float top = 600.0f - pos.y;

    CGPoint position;

    int32_t stepWeightTotal = [[MGame sharedGame] weightFunctionStep];
    int32_t itemWeightTotal = [[MGame sharedGame] weightFunctionItem];

    MTowerObjectType type;

    MSpriteTowerStepBase* step;
    MSpriteTowerItemBase* item;

    while (self.upperBound < top)
    {
        position = CGPointMake(
            stepColumnWidth * (float)self.randomStepColumn.randomInteger + (float)self.randomStepVariance.randomInteger + 38.0f,
            self.upperBound);

        type = [[MGame sharedGame] stepWithParameter:arc4random_uniform(stepWeightTotal) inStage:self.upperBound / 600];

        step = [MSpriteTowerStepBase stepWithType:type
                                         position:position
                                             usid:0
                                             seed:0];

        [self.stepCollection addObject:step];

        [self.sprites addChild:step];

        if ((type == MTowerObjectTypeStepDrift) ||
            (type == MTowerObjectTypeStepMovingWalkwayLeft) ||
            (type == MTowerObjectTypeStepMovingWalkwayRight) ||
            (type == MTowerObjectTypeStepPulse) ||
            (type == MTowerObjectTypeStepSpring) ||
            (type == MTowerObjectTypeStepSteady))

        {
            if (arc4random_uniform(10) <= 1)
            {
                type = [[MGame sharedGame] itemWithParameter:arc4random_uniform(itemWeightTotal) inStage:self.upperBound / 600];

                item = [MSpriteTowerItemBase itemWithType:type
                                           position:position
                                               uiid:0
                                               seed:1];

                [self.itemCollection addObject:item];

                [self.sprites addChild:item];
            }
        }

        self.upperBound += stepInterval;
    }
}

//------------------------------------------------------------------------------
@end
