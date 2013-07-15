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
#import "MSpriteTowerItem.h"
#import "MSpriteTowerStage.h"
#import "MSpriteTowerStep.h"
#import "UMath.h"


//------------------------------------------------------------------------------
@interface MSpriteTowerStage()
@property (nonatomic, strong, readwrite) NSArray* steps;
@property (nonatomic, strong, readwrite) NSArray* items;
@property (nonatomic, assign, readwrite) uint32_t stageIndex;
@property (nonatomic, assign, readwrite) uint32_t frameIndex;
@property (nonatomic, assign, readwrite) uint32_t seed;
@property (nonatomic, assign, readwrite) NSRange objectRange;
@property (nonatomic, assign, readwrite) NSRange markupRange;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerStage
//------------------------------------------------------------------------------
+(id) basementStage
{
    return [[MSpriteTowerStage alloc] initWithBasement];
}

//------------------------------------------------------------------------------
+(id) menuMainStage
{
    return [[self alloc] initWithMenuMain];
}


//------------------------------------------------------------------------------
+(id) stageWithIndex:(uint32_t)index
          baseHeight:(NSUInteger)baseHeight
                seed:(uint32_t)seed
{
    //--check the top-most stage for match game here

    id stage;

    if (index == 0)
    {
        stage = [[MSpriteTowerStage alloc] initWithBasement];;
    }
    else
    {
        stage = [[MSpriteTowerStage alloc] initWithIndex:index baseHeight:baseHeight seed:seed];
    }

    return stage;
}

//------------------------------------------------------------------------------
-(id) initWithBasement
{
    self = [super initWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Texture/step.pvr.ccz"]
                             rect:CGRectZero];

    if (self)
    {
        self.stageIndex = 0;
        self.frameIndex = 0;
        self.seed = 0;

        self.steps = [NSMutableArray new];
        self.items = [NSMutableArray new];

        //--
        self.objectRange = NSMakeRange(0, 0);
        self.markupRange = NSMakeRange(0, 0);

        //--
        MSpriteTowerStepBase* step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepBasement
                                                               position:CGPointMake(160.0f, 0.0f)
                                                                   usid:(MTowerObjectGroupStep << 31)
                                                                   seed:0];

        [(NSMutableArray*)self.steps addObject:step];
    }

    return self;
}

//------------------------------------------------------------------------------
-(id) initWithMenuMain
{
    self = [super initWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Texture/step.pvr.ccz"]
                             rect:CGRectZero];

    if (self)
    {
        //
        self.stageIndex = 1;
        self.frameIndex = 0;
        self.seed = 0;

        //--
        self.objectRange = NSMakeRange(0, 0);
        self.markupRange = NSMakeRange(0, 0);

        //
        self.steps = [NSMutableArray new];
        self.items = [NSMutableArray new];

        //
        NSMutableArray* steps = (NSMutableArray*)self.steps;

        MSpriteTowerStepBase* step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                                                               position:ccp(40.0f, 200.0f)
                                                                   usid:0
                                                                   seed:0];

        [steps addObject:step];

        [self addChild:step];

        //
        step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                                         position:ccp(260.0f, 280.0f)
                                             usid:0
                                             seed:0];

        [steps addObject:step];

        [self addChild:step];

        //
        step = [MSpriteTowerStepBase stepWithType:MTowerObjectTypeStepSteady
                                         position:ccp(160.0f, 40.0f)
                                             usid:0
                                             seed:0];

        [steps addObject:step];

        [self addChild:step];

        //
        NSMutableArray* items = (NSMutableArray*)self.items;

        MSpriteTowerItemBase* item;

        item = [MSpriteTowerItemBase itemWithType:MTowerObjectTypeItemCat
                                   position:ccp(270.0f, 280.0f)
                                       uiid:0
                                       seed:0];

        [items addObject:item];

        [self addChild:item];

        item = [MSpriteTowerItemBase itemWithType:MTowerObjectTypeItemMilkStrength
                                   position:ccp(60.0f, 200.0f)
                                       uiid:0
                                       seed:0];

        [items addObject:item];

        [self addChild:item];
    }

    return self;
}

//------------------------------------------------------------------------------
-(id) initWithIndex:(uint32_t)index
         baseHeight:(NSUInteger)baseHeight
               seed:(uint32_t)seed
{
    self = [super initWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Texture/step.pvr.ccz"]
                             rect:CGRectZero];

    if (self)
    {
        //
        self.stageIndex = index;
        self.frameIndex = 0;
        self.seed = seed;

        //
        self.steps = [NSMutableArray new];
        self.items = [NSMutableArray new];

        //
        [self buildStepsAndItemsWithBaseHeight:baseHeight];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) buildStepsAndItemsWithBaseHeight:(NSUInteger)baseHeight
{
    float stepInterval       = 30.0f;
    float stepColumnWidth    = 72.0f;
    float stepColumnVariance = 16.0f;

    //--random generator
    URandomIntegerGeneratorMWC* randomStepVariance =
        [URandomIntegerGeneratorMWC randomIntegerGeneratorWithRange:URandomIntegerRangeMake(0, (int32_t)stepColumnVariance)
                                                              seedA:self.stageIndex + 1
                                                              seedB:self.seed];

    UAverageRandomIntegerGeneratorMWC* randomStepColumn =
        [UAverageRandomIntegerGeneratorMWC averageRandomIntegerGeneratorWithRange:URandomIntegerRangeMake(0, 3)
                                                                            seedA:self.stageIndex + 1
                                                                            seedB:self.seed];

    //--
    int32_t reference  = baseHeight + stepInterval;
    int32_t lowerBound = reference;
    int32_t upperBound = reference;

    CGPoint position;

    uint32_t usidm = (MTowerObjectGroupStep << 31) | (self.stageIndex << 16);
    uint32_t usidi = 0;
    uint32_t usidc;

    uint32_t uiidm = (MTowerObjectGroupItem << 31) | (self.stageIndex << 16);
    uint32_t uiidi = 0;
    uint32_t uiidc;

    int32_t stepWeightTotal = [[MGame sharedGame] weightFunctionStep];
    int32_t itemWeightTotal = [[MGame sharedGame] weightFunctionItem];

    MTowerObjectType type;

    MSpriteTowerStepBase* step;
    MSpriteTowerItemBase* item;

    NSMutableArray* steps = (NSMutableArray*)self.steps;
    NSMutableArray* items = (NSMutableArray*)self.items;

    for (int32_t i = 0; i < 20; ++i, reference += stepInterval)
    {
        position = CGPointMake(
            stepColumnWidth * (float)randomStepColumn.randomInteger + (float)randomStepVariance.randomInteger + 38.0f,
            reference);

        usidc = (usidm | usidi);

        type = [[MGame sharedGame] stepWithParameter:arc4random_uniform(stepWeightTotal) inStage:self.stageIndex];

        step = [MSpriteTowerStepBase stepWithType:type
                                         position:position
                                             usid:usidc
                                             seed:self.seed];

        [steps addObject:step];

        [self addChild:step];

        lowerBound = MIN(lowerBound, step.range.location);
        upperBound = MAX(upperBound, NSMaxRange(step.range));

        usidi += 1;

        if ((type == MTowerObjectTypeStepDrift) ||
            (type == MTowerObjectTypeStepMovingWalkwayLeft) ||
            (type == MTowerObjectTypeStepMovingWalkwayRight) ||
            (type == MTowerObjectTypeStepPulse) ||
            (type == MTowerObjectTypeStepSpring) ||
            (type == MTowerObjectTypeStepSteady))

        {
            if (arc4random_uniform(10) <= 1)
            {
                uiidc = (uiidm | uiidi);

                type = [[MGame sharedGame] itemWithParameter:arc4random_uniform(itemWeightTotal) inStage:self.stageIndex];

                item = [MSpriteTowerItemBase itemWithType:type
                                           position:position
                                               uiid:uiidc
                                               seed:self.seed];

                [items addObject:item];

                [self addChild:item];

                lowerBound = MIN(lowerBound, item.range.location);
                upperBound = MAX(upperBound, NSMaxRange(item.range));

                uiidi += 1;
            }
        }
    }

    self.markupRange = NSMakeRange(baseHeight, reference - stepInterval - baseHeight);
    self.objectRange = NSMakeRange(lowerBound, upperBound - lowerBound);
}

//------------------------------------------------------------------------------
-(NSArray*) collideItemWithPosition:(CGPoint)positionOld
                           velocity:(CGPoint)velocity
                              bound:(CGRect)bound
{
    NSRange r = self.objectRange;

    float lowerBound = r.location;
    float upperBound = NSMaxRange(r);

    CGPoint positionNew = ccpAdd(positionOld, velocity);

    NSMutableArray* items = nil;

    float boundBoyMinY = CGRectGetMinY(bound);
    float boundBoyMaxY = CGRectGetMaxY(bound);

    if ((positionOld.y + boundBoyMaxY < lowerBound) ||
        (positionOld.y + boundBoyMinY > upperBound))
    {
    }
    else if ((positionNew.y + boundBoyMaxY < lowerBound) ||
             (positionNew.y + boundBoyMinY > upperBound))
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

    if (velocity->y >= 0.0f)
    {
        //--collide during dropping

        step = nil;
    }
    else
    {
        //--collide stage
        CGPoint positionNew = ccpAdd(positionOld, *velocity);

        NSRange r = self.objectRange;

        float lowerBound = r.location;
        float upperBound = NSMaxRange(r);

        float boundBoyMinY = CGRectGetMinY(bound);
        float boundBoyMaxY = CGRectGetMaxY(bound);

        if ((lowerBound > positionOld.y + boundBoyMaxY) && (lowerBound > positionNew.y + boundBoyMaxY))
        {
            //--rect is under the stage

            step = nil;
        }
        else if ((upperBound < positionOld.y + boundBoyMinY) && (upperBound < positionNew.y + boundBoyMinY))
        {
            //--rect is on the top of stage

            step = nil;
        }
        else
        {
            //--collide
            CGRect boundStep;

            float boundBoyMinX = CGRectGetMinX(bound);
            float boundBoyMaxX = CGRectGetMaxX(bound);

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
-(void) updateToFrame:(int32_t)frame
{
    if (self.frameIndex != frame)
    {
        self.frameIndex = frame;

        for (MSpriteTowerStepBase* step in self.steps)
        {
            [step updateToFrame:frame];
        }

        for (MSpriteTowerItemBase* item in self.items)
        {
            [item updateToFrame:frame];
        }
    }
}

//------------------------------------------------------------------------------
@end
