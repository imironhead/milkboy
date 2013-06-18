//
//  MTowerStage.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MGame.h"
#import "MTowerItem.h"
#import "MTowerStage.h"
#import "MTowerStep.h"
#import "UMath.h"


//------------------------------------------------------------------------------
@interface MTowerStage()
@property (nonatomic, strong, readwrite) NSArray* steps;
@property (nonatomic, strong, readwrite) NSArray* items;
@property (nonatomic, assign, readwrite) uint32_t stageIndex;
@property (nonatomic, assign, readwrite) uint32_t frameIndex;
@property (nonatomic, assign, readwrite) uint32_t seed;
@property (nonatomic, assign, readwrite) MCollisionRange rangeCollision;
@property (nonatomic, assign) BOOL matchGame;
@property (nonatomic, assign) float stepHeight;
@property (nonatomic, assign) float stepInterval;
@end

//------------------------------------------------------------------------------
@implementation MTowerStage
//------------------------------------------------------------------------------
+(id) stageWithIndex:(uint32_t)index seed:(uint32_t)seed matchGame:(BOOL)matchGame
{
    //--check the top-most stage for match game here

    id stage;

    if (index == 0)
    {
        stage = [[MTowerStage alloc] initWithZeroIndex];
    }
    else
    {
        stage = [[MTowerStage alloc] initWithIndex:index seed:seed matchGame:matchGame];
    }

    return stage;
}

//------------------------------------------------------------------------------
-(id) initWithZeroIndex
{
    self = [super init];

    if (self)
    {
        self.stageIndex = 0;
        self.frameIndex = 0;
        self.seed = 0;
        self.matchGame = FALSE;

        self.steps = [NSMutableArray new];
        self.items = [NSMutableArray new];

        //--
        [self buildBasement];
    }

    return self;
}

//------------------------------------------------------------------------------
-(id) initWithIndex:(uint32_t)index seed:(uint32_t)seed matchGame:(BOOL)matchGame
{
    self = [super init];

    if (self)
    {
        //
        self.stageIndex = index;
        self.frameIndex = 0;
        self.seed = seed;
        self.matchGame = matchGame;

        //
        self.steps = [NSMutableArray new];
        self.items = [NSMutableArray new];

        //
        [self buildSteps];
        [self buildItems];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) buildSteps
{
    float stepHeight         = 16.0f;
    float stepInterval       = 30.0f;
    float stepColumnWidth    = 72.0f;
    float stepColumnVariance = 16.0f;

    self.stepHeight = stepHeight;
    self.stepInterval = stepInterval;

    //--random generator
    URandomIntegerGeneratorMWC* randomStepVariance =
        [URandomIntegerGeneratorMWC randomIntegerGeneratorWithRange:URandomIntegerRangeMake(0, (int32_t)stepColumnVariance)
                                                              seedA:self.stageIndex + 1
                                                              seedB:self.seed];

    UAverageRandomIntegerGeneratorMWC* randomStepColumn =
        [UAverageRandomIntegerGeneratorMWC averageRandomIntegerGeneratorWithRange:URandomIntegerRangeMake(0, 3)
                                                                            seedA:self.stageIndex + 1
                                                                            seedB:self.seed];

//    JTowerObjectTypeGenerator* randomStepDice =
//        [JTowerObjectTypeGenerator generatorWithMatchGame:self.matchGame
//                                                    group:JTowerObjectGroupStep
//                                                    stage:self.stageIndex
//                                                     seed:self.seed];

    //--
    MCollisionRange rangeFix = MCollisionRangeMake((float)(self.stageIndex * 600) - 600.0f, (float)(self.stageIndex * 600));
    MCollisionRange rangeVar = rangeFix;

    rangeFix.lowerBound += stepHeight;

    CGPoint position;

    uint32_t usidm = (MTowerObjectGroupStep << 31) | (self.stageIndex << 16);
    uint32_t usidi = 0;
    uint32_t usidc;

    int32_t weightTotal = [[MGame sharedGame] weightFunctionStep];

    MTowerObjectType type;

    MTowerStepBase* step;

    NSMutableArray* steps = (NSMutableArray*)self.steps;

    while (rangeFix.lowerBound < rangeFix.upperBound)
    {
        position = CGPointMake(
            stepColumnWidth * (float)randomStepColumn.randomInteger + (float)randomStepVariance.randomInteger + 38.0f,
            rangeFix.lowerBound);

        usidc = (usidm | usidi);

        type = [[MGame sharedGame] stepWithParameter:arc4random_uniform(weightTotal) inStage:self.stageIndex];

        step = [MTowerStepBase stepWithType:type
                                   position:position
                                       usid:usidc
                                       seed:self.seed];

        [steps addObject:step];

        rangeVar.lowerBound = MIN(rangeVar.lowerBound, step.rangeCollision.lowerBound);
        rangeVar.upperBound = MAX(rangeVar.upperBound, step.rangeCollision.upperBound);

        usidi += 1;

        rangeFix.lowerBound += stepInterval;
    }

    self.rangeCollision = rangeVar;
}

//------------------------------------------------------------------------------
-(void) buildItems
{
    //--
    MCollisionRange rangeFix = MCollisionRangeMake((float)(self.stageIndex * 600) - 600.0f, (float)(self.stageIndex * 600));

    CGPoint position;

    uint32_t uiidm = (MTowerObjectGroupItem << 31) | (self.stageIndex << 16);
    uint32_t uiidi = 0;
    uint32_t uiidc;

    int32_t weightTotal = [[MGame sharedGame] weightFunctionItem];

    MTowerObjectType type;

    MTowerItemBase* item;

    NSMutableArray* items = (NSMutableArray*)self.items;

    while (rangeFix.lowerBound < rangeFix.upperBound)
    {
        rangeFix.lowerBound += 30.0f;

        if (arc4random_uniform(10) > 1)
        {
            continue;
        }

        position.y = rangeFix.lowerBound;
        position.x = 16.0f + (float)arc4random_uniform(278);

        uiidc = (uiidm | uiidi);

        type = [[MGame sharedGame] itemWithParameter:arc4random_uniform(weightTotal) inStage:self.stageIndex];

        item = [MTowerItemBase itemWithType:type
                                   position:position
                                       uiid:uiidc
                                       seed:self.seed];

        [items addObject:item];

        uiidi += 1;
    }
}

//------------------------------------------------------------------------------
-(void) buildBasement
{
    self.rangeCollision = MCollisionRangeMake(
        (float)(self.stageIndex * 600) - 600.0f,
        (float)(self.stageIndex * 600));

    self.stepInterval = 600.0f;

    NSMutableArray* steps = (NSMutableArray*)self.steps;

    MTowerStepBase* step = [MTowerStepBase stepWithType:MTowerObjectTypeStepStation
                                               position:CGPointMake(160.0f, 0.0f)
                                                   usid:(MTowerObjectGroupStep << 31)
                                                   seed:0];

    [steps addObject:step];
}

//------------------------------------------------------------------------------
-(NSArray*) collideItemWithPosition:(CGPoint)positionOld
                           velocity:(CGPoint)velocity
                              bound:(CGRect)bound
{
    MCollisionRange r = self.rangeCollision;

    CGPoint positionNew = ccpAdd(positionOld, velocity);

    NSMutableArray* items = nil;

    float boundBoyMinY = CGRectGetMinY(bound);
    float boundBoyMaxY = CGRectGetMaxY(bound);

    if ((positionOld.y + boundBoyMaxY < r.lowerBound) ||
        (positionOld.y + boundBoyMinY > r.upperBound))
    {
    }
    else if ((positionNew.y + boundBoyMaxY < r.lowerBound) ||
             (positionNew.y + boundBoyMinY > r.upperBound))
    {
    }
    else
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

        for (MTowerItemBase* item in self.items)
        {
            if (!item.live)
            {
                continue;
            }

            boundItem = item.boundCollision;

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
-(MTowerStepBase*) collideStepWithPosition:(CGPoint)positionOld
                                  velocity:(CGPoint*)velocity
                                     bound:(CGRect)bound
{
    //--collide with upper edge of bounding rect of steps
    MTowerStepBase* step = nil;

    if (velocity->y >= 0.0f)
    {
        //--collide during dropping

        step = nil;
    }
    else
    {
        //--collide stage
        CGPoint positionNew = ccpAdd(positionOld, *velocity);

        MCollisionRange range = self.rangeCollision;

        float boundBoyMinY = CGRectGetMinY(bound);
        float boundBoyMaxY = CGRectGetMaxY(bound);

        if ((range.lowerBound > positionOld.y + boundBoyMaxY) && (range.lowerBound > positionNew.y + boundBoyMaxY))
        {
            //--rect is under the stage

            step = nil;
        }
        else if ((range.upperBound < positionOld.y + boundBoyMinY) && (range.upperBound < positionNew.y + boundBoyMinY))
        {
            //--rect is on the top of stage

            step = nil;
        }
        else
        {
            //--collide
            float dx;

            CGRect boundStep;

            float boundBoyMinX = CGRectGetMinX(bound);
            float boundBoyMaxX = CGRectGetMaxX(bound);

            float boundStepMinX;
            float boundStepMaxX;
            float boundStepMaxY;

            for (MTowerStepBase* stepT in self.steps)
            {
                if (!stepT.live)
                {
                    continue;
                }

                boundStep = stepT.boundCollision;

                boundStepMinX = CGRectGetMinX(boundStep) - boundBoyMaxX;
                boundStepMaxX = CGRectGetMaxX(boundStep) - boundBoyMinX;
                boundStepMaxY = CGRectGetMaxY(boundStep) - boundBoyMinY;

                if ((positionOld.y <= boundStepMaxY) || (positionNew.y > boundStepMaxY))
                {
                    continue;
                }

                dx =
                    positionOld.x +
                    (positionNew.x - positionOld.x) *
                    (boundStepMaxY - positionOld.y) / (positionNew.y - positionOld.y);

                if ((dx >= boundStepMinX) && (dx <= boundStepMaxX))
                {
                    step = stepT;

                    positionNew.x = dx;
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
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh
{
    if (self.frameIndex != frame)
    {
        self.frameIndex = frame;

        for (MTowerStepBase* step in self.steps)
        {
            [step jumpToFrame:frame refresh:refresh];
        }

        for (MTowerItemBase* item in self.items)
        {
            [item jumpToFrame:frame refresh:refresh];
        }
    }
}

//------------------------------------------------------------------------------
@end
