//
//  MLayerTowerObjects.m
//  Milkboy
//
//  Created by iRonhead on 7/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MGame.h"
#import "MLayerTower.h"
#import "MLayerTowerObjects.h"
#import "UMath.h"


//------------------------------------------------------------------------------
typedef struct _ObjectPosition
{
    MTowerObjectType    type;
    CGPoint             position;
} ObjectPosition;

//------------------------------------------------------------------------------
@interface MLayerTowerObjects ()
@property (nonatomic, assign, readwrite) float deadLine;
@property (nonatomic, strong) NSMutableArray* itemCollection;
@property (nonatomic, strong) NSMutableArray* stepCollection;
@property (nonatomic, strong) CCSpriteBatchNode* sprites;
@property (nonatomic, strong) URandomIntegerGeneratorMWC* randomStepVariance;
@property (nonatomic, strong) UAverageRandomIntegerGeneratorMWC* randomStepColumn;
@property (nonatomic, assign) float upperBoundStep;
@property (nonatomic, assign) float upperBoundItem;
@property (nonatomic, assign) NSInteger milkForMilkTutorial;
@property (nonatomic, assign) NSInteger flagForMilkTutorial;
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
        self.upperBoundStep = 0.0f;
        self.upperBoundItem = 0.0f;
        self.canClimb = TRUE;
        self.padding = 0.0f;

        self.itemCollection = [NSMutableArray array];
        self.stepCollection = [NSMutableArray array];

        //--batch nodes
        self.sprites = [CCSpriteBatchNode batchNodeWithFile:@"Texture/step.pvr.ccz"];

        [self addChild:self.sprites];

        //--basement
        [self addStepWithType:MTowerObjectTypeStepBasement position:CGPointMake(160.0f, 0.0f)];

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
        float d = padding - self->_padding;

        for (MSpriteTowerItem* item in self.items)
        {
            [item pad:d];
        }

        for (MSpriteTowerStep* step in self.steps)
        {
            [step pad:d];
        }

        self.deadLine += d;

        self.upperBoundStep += d;
        self.upperBoundItem += d;

        self->_padding = padding;
    }
}

//------------------------------------------------------------------------------
-(void) setUpperBoundStep:(float)upperBoundStep
{
    NSAssert(floorf(upperBoundStep) == upperBoundStep, @"[MLayerTowerObjects setUpperBoundStep:] accept integer only");

    self->_upperBoundStep = upperBoundStep;
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

        for (MSpriteTowerItem* item in self.items)
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
-(MSpriteTowerStep*) collideStepWithPosition:(CGPoint)positionOld
                                    velocity:(CGPoint*)velocity
                                       bound:(CGRect)bound
                                  frameIndex:(int32_t)frameIndex
{
    //--collide with upper edge of bounding rect of steps
    MSpriteTowerStep* step = nil;

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

        for (MSpriteTowerStep* stepT in self.steps)
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
-(void) addItemWithType:(MTowerObjectType)type position:(CGPoint)position token:(uint32_t)token
{
    MSpriteTowerItem* item = [MSpriteTowerItem factoryCreateItemWithType:type position:position token:token];

    [self.itemCollection addObject:item];

    [self.sprites addChild:item z:2];
}

//------------------------------------------------------------------------------
-(void) removeItem:(id)item
{
    if ([item class] == [MSpriteTowerItem class])
    {
        [MSpriteTowerItem factoryDeleteItem:item];

        [self.itemCollection removeObject:item];

        [self.sprites removeChild:item cleanup:TRUE];
    }
    else
    {
        for (MSpriteTowerItem* i in item)
        {
            [MSpriteTowerItem factoryDeleteItem:i];

            [self.itemCollection removeObject:i];

            [self.sprites removeChild:i cleanup:TRUE];
        }
    }
}

//------------------------------------------------------------------------------
-(void) addStepWithType:(MTowerObjectType)type position:(CGPoint)position
{
    MSpriteTowerStep* step = [MSpriteTowerStep factoryCreateStepWithType:type position:position];

    [self.stepCollection addObject:step];

    [self.sprites addChild:step z:1];
}

//------------------------------------------------------------------------------
-(void) removeStep:(id)step
{
    if ([step class] == [MSpriteTowerStep class])
    {
        [MSpriteTowerStep factoryDeleteStep:step];

        [self.stepCollection removeObject:step];

        [self.sprites removeChild:step cleanup:TRUE];
    }
    else
    {
        for (MSpriteTowerStep* s in step)
        {
            [MSpriteTowerStep factoryDeleteStep:s];

            [self.stepCollection removeObject:s];

            [self.sprites removeChild:s cleanup:TRUE];
        }
    }
}

//------------------------------------------------------------------------------
-(void) updateDeadLineWithBoy:(MLayerTowerBoy*)boy
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
            }
        }

        [self removeStep:dead];

        [dead removeAllObjects];

        for (CCSprite* sprite in self.itemCollection)
        {
            if (sprite.position.y < deadLineT)
            {
                [dead addObject:sprite];
            }
        }

        [self removeItem:dead];
    }

    //--add object to rise upper bound
    [self raiseUpperBoundOfGameTowerWithBoy:boy];
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    for (MSpriteTowerStep* step in self.steps)
    {
        [step updateToFrame:frame];
    }

    for (MSpriteTowerItem* item in self.items)
    {
        [item updateToFrame:frame];
    }

//    MTowerType type = [(MLayerTower*)self.parent.parent type];
//
//    if (type == MTowerTypeTutorialMilks)
//    {
//        BOOL hasFlavoredMilk = FALSE;
//
//        NSMutableArray* dead = [NSMutableArray array];
//
//        for (MSpriteTowerItemBase* item in self.itemCollection)
//        {
//            if (item.live)
//            {
//                if ((item.type == MTowerObjectTypeItemMilkAgile) ||
//                    (item.type == MTowerObjectTypeItemMilkDash) ||
//                    (item.type == MTowerObjectTypeItemMilkDoubleJump) ||
//                    (item.type == MTowerObjectTypeItemMilkGlide) ||
//                    (item.type == MTowerObjectTypeItemMilkStrength) ||
//                    (item.type == MTowerObjectTypeItemMilkStrengthExtra))
//                {
//                    hasFlavoredMilk = TRUE;
//                }
//            }
//            else
//            {
//                [dead addObject:item];
//
//                [self.sprites removeChild:item cleanup:TRUE];
//            }
//        }
//
//        if (dead.count)
//        {
//            [self.itemCollection removeObjectsInArray:dead];
//        }
//
//        if (!hasFlavoredMilk)
//        {
//            self.flagForMilkTutorial += 1;
//
//            if (self.flagForMilkTutorial > 30)
//            {
//                self.flagForMilkTutorial = 0;
//
//                self.milkForMilkTutorial += 1;
//
//                MTowerObjectType t;
//
//                switch (self.milkForMilkTutorial % 6)
//                {
//                case 0: t = MTowerObjectTypeItemMilkStrength; break;
//                case 1: t = MTowerObjectTypeItemMilkStrengthExtra; break;
//                case 2: t = MTowerObjectTypeItemMilkAgile; break;
//                case 3: t = MTowerObjectTypeItemMilkDash; break;
//                case 4: t = MTowerObjectTypeItemMilkDoubleJump; break;
//                case 5: t = MTowerObjectTypeItemMilkGlide; break;
//                }
//
//                MSpriteTowerItemBase* milk = [MSpriteTowerItemBase itemWithType:t
//                                                                       position:ccp(160.0f, 60.0f)
//                                                                           uiid:0
//                                                                           seed:0];
//
//                [self.itemCollection addObject:milk];
//
//                [self.sprites addChild:milk z:0];
//            }
//        }
//    }
}

//------------------------------------------------------------------------------
-(void) transformToType:(MTowerType)type
{
    //--move all visible steps & items up
    CGPoint pt;

    for (CCSprite* sprite in self.sprites.children)
    {
        pt = sprite.position;

        if ((pt.y < 600.0f) && (pt.y > 0.0f))
        {
            //--basement does not need move
            //--objects outside the screen do not need move

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

            if ((pt.y < 600.0f) && (pt.y > 0.0f))
            {
                //--basement does not need move
                //--objects outside the screen do not need move

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
    case MTowerTypeTutorialMilks:
        [self buildTutorialMilksTower];
        break;
    case MTowerTypeTutorialPower:
        [self buildTutorialPowerTower];
        break;
    case MTowerTypeTutorialScore:
        [self buildTutorialScoreTower];
        break;
    case MTowerTypeTutorialSteps:
        [self buildTutorialStepsTower];
        break;
    case MTowerTypeTutorialStory:
        [self buildTutorialStoryTower];
        break;
    case MTowerTypeTransition:
    case MTowerTypeTransitionPauseToQuit:
    case MTowerTypeTransitionPauseToRestart:
        NSAssert(0, @"[MLayerTowerObjects buildTowerWithType:]");
        break;
    }
}

//------------------------------------------------------------------------------
-(void) buildTableTower:(ObjectPosition*)table
{
    ObjectPosition* p = table;

    while (p->type != MTowerObjectTypeInvalid)
    {
        if (p->type & MTowerObjectTypeItemBase)
        {
            [self addItemWithType:p->type position:p->position token:0];
        }
        else
        {
            [self addStepWithType:p->type position:p->position];
        }

        p += 1;
    }
}

//------------------------------------------------------------------------------
-(void) buildCleanTower
{
    [self removeItem:[NSArray arrayWithArray:self.itemCollection]];
    [self removeStep:[NSArray arrayWithArray:self.stepCollection]];

    [self addStepWithType:MTowerObjectTypeStepBasement position:CGPointMake(160.0f, 0.0f)];

    //--set padding first, since it will change the other value (upperBound & deadLine)
    self.padding = 0.0f;
    self.upperBoundStep = 30.0f;
    self.upperBoundItem = 30.0f;
    self.deadLine = 0.0f;

    //--
    [self.randomStepColumn reset];
}

//------------------------------------------------------------------------------
-(void) buildRegularTower
{
    [self buildCleanTower];

    ObjectPosition table[] =
    {
        {MTowerObjectTypeStepSteady,             40.0f, 200.0f},
        {MTowerObjectTypeStepSteady,            260.0f, 280.0f},
        {MTowerObjectTypeStepSteady,            160.0f,  40.0f},
        {MTowerObjectTypeItemCat,               270.0f, 280.0f},
        {MTowerObjectTypeItemCoinGold,           60.0f, 200.0f},
        {MTowerObjectTypeInvalid,                 0.0f,   0.0f},
    };

    [self buildTableTower:table];
}

//------------------------------------------------------------------------------
-(void) buildGameTower
{
    [self buildCleanTower];

    [self raiseUpperBoundOfGameTowerWithBoy:nil];
}

//------------------------------------------------------------------------------
-(void) buildTutorialMilksTower
{
    self.milkForMilkTutorial = -1;
    self.flagForMilkTutorial = 0;

    [self buildCleanTower];

    ObjectPosition table[] =
    {
        {MTowerObjectTypeStepSteady,             80.0f,   60.0f},
        {MTowerObjectTypeStepSteady,            160.0f,   60.0f},
        {MTowerObjectTypeStepSteady,            240.0f,   60.0f},
        {MTowerObjectTypeItemCoinGold,           62.0f,   60.0f},
        {MTowerObjectTypeItemCoinGold,           80.0f,   60.0f},
        {MTowerObjectTypeItemCoinGold,           98.0f,   60.0f},
        {MTowerObjectTypeItemCoinGold,          222.0f,   60.0f},
        {MTowerObjectTypeItemCoinGold,          240.0f,   60.0f},
        {MTowerObjectTypeItemCoinGold,          258.0f,   60.0f},
        {MTowerObjectTypeInvalid,                 0.0f,    0.0f},
    };

    [self buildTableTower:table];
}

//------------------------------------------------------------------------------
-(void) buildTutorialPowerTower
{
    [self buildCleanTower];

    ObjectPosition table[] =
    {
        {MTowerObjectTypeStepSteady,             80.0f,  80.0f},
        {MTowerObjectTypeStepSteady,            160.0f,  60.0f},
        {MTowerObjectTypeStepSteady,            240.0f,  80.0f},
        {MTowerObjectTypeInvalid,                 0.0f,   0.0f},
    };

    [self buildTableTower:table];
}

//------------------------------------------------------------------------------
-(void) buildTutorialScoreTower
{
    [self buildCleanTower];

    ObjectPosition table[] =
    {
        {MTowerObjectTypeStepSteady,            160.0f,  60.0f},
        {MTowerObjectTypeItemCoinGold,          160.0f,  60.0f},
        {MTowerObjectTypeInvalid,                 0.0f,   0.0f},
    };

    [self buildTableTower:table];
}

//------------------------------------------------------------------------------
-(void) buildTutorialStepsTower
{
    [self buildCleanTower];

    ObjectPosition table[] =
    {
        {MTowerObjectTypeStepDrift,             270.0f, 120.0f},
        {MTowerObjectTypeStepMovingWalkwayLeft, 190.0f,  90.0f},
        {MTowerObjectTypeStepSpring,            120.0f,  60.0f},
        {MTowerObjectTypeStepSteady,             40.0f,  30.0f},
        {MTowerObjectTypeInvalid,                 0.0f,   0.0f},
    };

    [self buildTableTower:table];
}

//------------------------------------------------------------------------------
-(void) buildTutorialStoryTower
{
    [self buildCleanTower];

    ObjectPosition table[] =
    {
        {MTowerObjectTypeStepSteady,    155.0f,  90.0f},
        {MTowerObjectTypeStepSteady,    235.0f,  60.0f},
        {MTowerObjectTypeStepSteady,     75.0f,  60.0f},
        {MTowerObjectTypeStepSteady,    155.0f,  30.0f},
        {MTowerObjectTypeInvalid,         0.0f,   0.0f},
    };

    [self buildTableTower:table];
}

//------------------------------------------------------------------------------
-(void) raiseUpperBoundOfGameTowerWithBoy:(MLayerTowerBoy*)boy
{
    //
    const float stepColumnVariance = 22.0f;

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

    MGame* game = [MGame sharedGame];

    CGPoint pos = self.parent.position;

    float top = 600.0f - pos.y;

    CGPoint position;

    int32_t stepWeightTotal = [game weightFunctionStep];
    int32_t itemWeightTotal = [game weightFunctionItem];

    MTowerObjectType typeItem;
    MTowerObjectType typeStep;

    uint32_t column;
    uint32_t stage;

    while (self.upperBoundStep < top)
    {
        stage = self.upperBoundStep / 600;

        column = self.randomStepColumn.randomInteger;

        position.y = self.upperBoundStep;

        switch (column)
        {
        case 0:
            if ((stage < 5) || (arc4random_uniform(10) < 8))
            {
                int32_t variance = (stage > 20) ? 10 : (stage / 2);

                position.x = (float)(38 + arc4random_uniform(variance));
            }
            else
            {
                position.x = 38.0f + 30.0f;
            }
            break;
        case 1:
            {
                int32_t variance = (stage > 20) ? 20 : stage;

                position.x = (float)(117 - variance / 2 + arc4random_uniform(variance));
            }
            break;
        case 2:
            {
                int32_t variance = (stage > 20) ? 20 : stage;

                position.x = (float)(193.0f - variance / 2 + arc4random_uniform(variance));
            }
            break;
        case 3:
            if ((stage < 5) || (arc4random_uniform(10) < 8))
            {
                int32_t variance = (stage > 20) ? 10 : (stage / 2);

                position.x = (float)(272 - arc4random_uniform(variance));
            }
            else
            {
                position.x = 272.0f - 30.0f;
            }
            break;
        }

        typeStep = [game stepWithParameter:arc4random_uniform(stepWeightTotal) inStage:stage];

        [self addStepWithType:typeStep position:position];

        self.upperBoundStep += [game stepIntervalInStage:stage];

        if (self.upperBoundItem >= self.upperBoundStep)
        {
            //--some items are generated before, skip
        }
        else if (arc4random_uniform(1000) <= 500)
        {
            //--frequency of new items

            typeItem = [game itemWithParameter:arc4random_uniform(itemWeightTotal) inStage:stage];

            //--check position and type
            if ((typeItem != MTowerObjectTypeItemBombBig) &&
                (typeItem != MTowerObjectTypeItemBombSmall) &&
                (typeItem != MTowerObjectTypeItemCoinGold))
            {
                if ((typeStep == MTowerObjectTypeStepMoveLeft) ||
                    (typeStep == MTowerObjectTypeStepMoveRight) ||
                    (typeStep == MTowerObjectTypeStepPatrolHorizontal) ||
                    (typeStep == MTowerObjectTypeStepPatrolVertical) ||
                    (typeStep == MTowerObjectTypeStepPulse))
                {
                    //--most items does not flow in air

                    return;
                }
            }

            switch (typeItem)
            {
            case MTowerObjectTypeItemCoinGold:
                {
                    if (1 && (stage > 1) && (arc4random_uniform(1000) < 50))
                    {
                        //--generate a large coin pattern
                        switch (arc4random_uniform(5))
                        {
                        case 0:
                            {
                                float dx = 2.0f;
                                float dy = 22.0f;

                                if ((position.x + dx > 300.0f) || (position.x + dx < 10.0f))
                                {
                                    dx = -dx;
                                }

                                [self addItemWithType:MTowerObjectTypeItemBombBig position:position token:0];

                                position.x += dx;
                                position.y += 40.0f;

                                for (int i = 0; i < 20; ++i)
                                {
                                    [self addItemWithType:MTowerObjectTypeItemCoinGold position:position token:0];

                                    if ((position.x + dx > 300.0f) || (position.x + dx < 10.0f))
                                    {
                                        dx = -dx;
                                    }

                                    position.x += dx;
                                    position.y += dy;
                                }
                            }
                            break;
                        case 1:
                            {
                                typedef struct _Coin
                                {
                                    CGPoint p;
                                    int32_t c;
                                } Coin;

                                Coin coins[] =
                                {
                                    {155.0f,   0.0f, 1},
                                    {144.0f,  22.0f, 2},
                                    {133.0f,  44.0f, 3},
                                    {122.0f,  66.0f, 4},
                                    {111.0f,  88.0f, 5},
                                    {122.0f, 110.0f, 1}, {177.0f, 110.0f, 1},
                                    {  0.0f,   0.0f, 0},
                                };

                                CGPoint p = position;

                                int32_t i = 0;

                                while (coins[i].c > 0)
                                {
                                    p.x = coins[i].p.x;
                                    p.y = coins[i].p.y + position.y;

                                    for (int32_t c = 0; c < coins[i].c; ++c)
                                    {
                                        p.x += 22.0f;

                                        [self addItemWithType:MTowerObjectTypeItemCoinGold position:p token:0];
                                    }

                                    i += 1;
                                }

                                position.y += 110.0f + 22.0f;
                            }
                            break;
                        }

                        self.upperBoundItem = position.y;
                    }
                    else
                    {
                        //--simple coin lines on step
                        [self addItemWithType:MTowerObjectTypeItemCoinGold position:position token:0];
                        [self addItemWithType:MTowerObjectTypeItemCoinGold position:CGPointMake(position.x - 24.0f, position.y) token:0];
                        [self addItemWithType:MTowerObjectTypeItemCoinGold position:CGPointMake(position.x + 24.0f, position.y) token:0];

                        self.upperBoundItem = self.upperBoundStep;
                    }
                }
                break;
            case MTowerObjectTypeItemSuitAstronaut:
            case MTowerObjectTypeItemSuitCEO:
            case MTowerObjectTypeItemSuitFootballPlayer:
            case MTowerObjectTypeItemSuitNinja:
            case MTowerObjectTypeItemSuitSuperhero:
                {
                    if (boy)
                    {
                        if ((typeItem == MTowerObjectTypeItemSuitAstronaut) && (boy.suit == MBoySuitAstronaut))
                        {
                            typeItem = MTowerObjectTypeItemSuitCEO;
                        }
                        else if ((typeItem == MTowerObjectTypeItemSuitCEO) && (boy.suit == MBoySuitCEO))
                        {
                            typeItem = MTowerObjectTypeItemSuitFootballPlayer;
                        }
                        else if ((typeItem == MTowerObjectTypeItemSuitFootballPlayer) && (boy.suit == MBoySuitFootballPlayer))
                        {
                            typeItem = MTowerObjectTypeItemSuitNinja;
                        }
                        else if ((typeItem == MTowerObjectTypeItemSuitNinja) && (boy.suit == MBoySuitNinja))
                        {
                            typeItem = MTowerObjectTypeItemSuitSuperhero;
                        }
                        else if ((typeItem == MTowerObjectTypeItemSuitSuperhero) && (boy.suit == MBoySuitSuperhero))
                        {
                            typeItem = MTowerObjectTypeItemSuitAstronaut;
                        }

                        [self addItemWithType:typeItem position:position token:0];
                    }

                    self.upperBoundItem = self.upperBoundStep;
                }
                break;
            default:
                {
                    [self addItemWithType:typeItem position:position token:0];

                    self.upperBoundItem = self.upperBoundStep;
                }
                break;
            }
            
        }
    }
}

//------------------------------------------------------------------------------
@end
