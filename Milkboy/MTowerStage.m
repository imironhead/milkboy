//
//  MTowerStage.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MTowerItem.h"
#import "MTowerStage.h"
#import "MTowerStep.h"


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
    float stepWidth          = 75.0f;
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

    URect bound;

    uint32_t usidm = (MTowerObjectGroupStep << 31) | (self.stageIndex << 16);
    uint32_t usidi = 0;
    uint32_t usidc;

    MTowerStepBase* step;

    NSMutableArray* steps = (NSMutableArray*)self.steps;

    while (rangeFix.lowerBound < rangeFix.upperBound)
    {
        bound.bottom = rangeFix.lowerBound;
        bound.top    = rangeFix.lowerBound + stepHeight;

        bound.left   =
            stepColumnWidth * (float)randomStepColumn.randomInteger +
            (float)randomStepVariance.randomInteger;
        bound.right  = bound.left + stepWidth;

        usidc = (usidm | usidi);

        step = [MTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                             collisionBound:bound
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

    MTowerItemBase* item;

    NSMutableArray* items = (NSMutableArray*)self.items;

    while (rangeFix.lowerBound < rangeFix.upperBound)
    {
        rangeFix.lowerBound += 30.0f;

        if (arc4random_uniform(10))
        {
            continue;
        }

        position.y = rangeFix.lowerBound;
        position.x = 16.0f + (float)arc4random_uniform(278);

        uiidc = (uiidm | uiidi);

        item = [MTowerItemBase itemWithType:MTowerObjectTypeItemMilk
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

    URect bound = URectMake(
        0.0f,
        -16.0f,
        320.0f,
        0.0f);

    NSMutableArray* steps = (NSMutableArray*)self.steps;

    MTowerStepBase* step = [MTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                                         collisionBound:bound
                                                   usid:(MTowerObjectGroupStep << 31)
                                                   seed:0];

    step.sprite.scaleX = 10.0f;

    [steps addObject:step];
}

//------------------------------------------------------------------------------
-(NSArray*) collideItemWithPosition:(CGPoint)positionOld
                           velocity:(CGPoint)velocity
                              bound:(URect)bound
{
    MCollisionRange r = self.rangeCollision;

    CGPoint positionNew = ccpAdd(positionOld, velocity);

    NSMutableArray* items = nil;

    if ((positionOld.y + bound.top    < r.lowerBound) ||
        (positionOld.y + bound.bottom > r.upperBound))
    {
    }
    else if ((positionNew.y + bound.top    < r.lowerBound) ||
             (positionNew.y + bound.bottom > r.upperBound))
    {
    }
    else
    {
        items = [NSMutableArray array];

        URect boundItem;

        CGPoint pUpper;
        CGPoint pLower;
        CGPoint pLeft;
        CGPoint pRight;

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

            boundItem.top    -= bound.bottom;
            boundItem.bottom -= bound.top;

            if ((pUpper.y < boundItem.bottom) || (pLower.y > boundItem.top))
            {
                continue;
            }

            boundItem.left  -= bound.right;
            boundItem.right -= bound.left;

            if ((pLeft.x > boundItem.right) || (pRight.x < boundItem.left))
            {
                continue;
            }

            if (velocity.y == 0.0f)
            {
                [items addObject:item];

                continue;
            }

            if (pLeft.x >= boundItem.left)
            {
                if (pLeft.y > boundItem.top)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundItem.top, boundItem.left),
                        CGPointMake(boundItem.top, boundItem.right)))
                    {
                        [items addObject:item];
                    }
                }
                else if (pLeft.y < boundItem.bottom)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundItem.bottom, boundItem.left),
                        CGPointMake(boundItem.bottom, boundItem.right)))
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
                    CGPointMake(boundItem.left, boundItem.top),
                    CGPointMake(boundItem.left, boundItem.bottom)))
                {
                    [items addObject:item];
                }
                else if (pLeft.y > boundItem.top)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundItem.top, boundItem.left),
                        CGPointMake(boundItem.top, boundItem.right)))
                    {
                        [items addObject:item];
                    }
                }
                else if (pLeft.y < boundItem.bottom)
                {
                    if (ccpSegmentIntersect(
                        pLeft,
                        pRight,
                        CGPointMake(boundItem.bottom, boundItem.left),
                        CGPointMake(boundItem.bottom, boundItem.right)))
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
                                     bound:(URect)bound
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

        if ((range.lowerBound > positionOld.y + bound.top) && (range.lowerBound > positionNew.y + bound.top))
        {
            //--rect is under the stage

            step = nil;
        }
        else if ((range.upperBound < positionOld.y + bound.bottom) && (range.upperBound < positionNew.y + bound.bottom))
        {
            //--rect is on the top of stage

            step = nil;
        }
        else
        {
            //--collide
            float dx;

            URect boundStep;

            for (MTowerStepBase* stepT in self.steps)
            {
                if (!stepT.live)
                {
                    continue;
                }

                boundStep = stepT.boundCollision;

                boundStep.left  -= bound.right;
                boundStep.right -= bound.left;
                boundStep.top   -= bound.bottom;

                if ((positionOld.y <= boundStep.top) || (positionNew.y > boundStep.top))
                {
                    continue;
                }

                dx =
                    positionOld.x +
                    (positionNew.x - positionOld.x) *
                    (boundStep.top - positionOld.y) / (positionNew.y - positionOld.y);

                if ((dx >= boundStep.left) && (dx <= boundStep.right))
                {
                    step = stepT;

                    positionNew.x = dx;
                    positionNew.y = boundStep.top;
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
