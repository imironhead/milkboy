//
//  MTower.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MBoy.h"
#import "MLayerTower.h"
#import "MTowerStage.h"
#import "MTowerStep.h"
#import "MWall.h"


//------------------------------------------------------------------------------
@interface MLayerTower()
@property (nonatomic, strong, readwrite) MBoyLocal* boyLocal;

@property (nonatomic, assign, readwrite) float waterLevel;
@property (nonatomic, assign, readwrite) float waterSpeed;

@property (nonatomic, strong) MWall* wall;
@property (nonatomic, strong) CCSpriteBatchNode* batchNodeSteps;

@property (nonatomic, strong) NSMutableArray* stagesInTower;
@property (nonatomic, strong) NSMutableArray* stagesVisible;

@property (nonatomic, assign) uint32_t seedLarge;
@property (nonatomic, assign) uint32_t seedSmall;
@property (nonatomic, assign) int32_t frameLocal;

@property (nonatomic, assign) BOOL powerUp;

@property (nonatomic, strong) CCLabelAtlas* labelPower;
@end

//------------------------------------------------------------------------------
@implementation MLayerTower
//------------------------------------------------------------------------------
+(id) layerWithMatch:(GKMatch*)match
{
    return [[self alloc] initWithMatch:match];
}

//------------------------------------------------------------------------------
-(id) initWithMatch:(GKMatch*)match
{
    self = [super init];

    if (self)
    {
        //
        [self scheduleUpdateWithPriority:0];

        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:TRUE];

        //--
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];

        [frameCache removeUnusedSpriteFrames];

        [frameCache addSpriteFramesWithFile:@"Texture/back.plist"];
        [frameCache addSpriteFramesWithFile:@"Texture/char.plist"];
        [frameCache addSpriteFramesWithFile:@"Texture/step.plist"];
        [frameCache addSpriteFramesWithFile:@"Texture/wall.plist"];

        //--
        self.seedLarge = 1 + arc4random_uniform(65534);
        self.seedSmall = self.seedLarge;

        //--
        self.wall = [MWall new];

        [self addChild:self.wall.spritesBack z:MTowerSpriteDepthBack];
        [self addChild:self.wall.spritesWall z:MTowerSpriteDepthWall];

        //--
        self.batchNodeSteps = [CCSpriteBatchNode batchNodeWithFile:@"Texture/step.pvr.ccz" capacity:32];

        [self addChild:self.batchNodeSteps z:MTowerSpriteDepthStep];

        //--initial stage
        MTowerStage* stage = [MTowerStage stageWithIndex:0 seed:0 matchGame:match != nil];

        self.stagesInTower = [NSMutableArray arrayWithObject:stage];
        self.stagesVisible = [NSMutableArray arrayWithObject:stage];

        //--boy
        self.boyLocal = [MBoyLocal new];

        [self addChild:self.boyLocal.sprite z:MTowerSpriteDepthChar];

        if (match)
        {
        }
        else
        {
            stage = [MTowerStage stageWithIndex:1 seed:self.seedLarge matchGame:FALSE];

            [self.stagesInTower addObject:stage];
            [self.stagesVisible addObject:stage];
        }

        //--
        for (stage in self.stagesVisible)
        {
            for (MTowerStepBase* step in stage.steps)
            {
                [self.batchNodeSteps addChild:step.sprite z:0];
            }
        }

        self.waterLevel = 0.0f;

        //
        self.labelPower =
            [CCLabelAtlas labelWithString:@"0"
                              charMapFile:@"fps_images.png"
                                itemWidth:12
                               itemHeight:32
                             startCharMap:'.'];

        self.labelPower.position = ccp(100.0f, 100.0f);
        self.labelPower.color = ccc3(0xff, 0xff, 0x80);

        [self addChild:self.labelPower z:9];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) update:(ccTime)elapsed
{
    [self updateLocalBoy];
    [self updateStage];
    [self updateCamera];
    [self updateWaterLevel];
}

//------------------------------------------------------------------------------
-(void) updateLocalBoy
{
    MBoyLocal* boy = self.boyLocal;

    //--power
    if (self.powerUp && boy.step && (boy.power < boy.powerMax))
    {
        boy.power += boy.powerAdd;

        if (boy.power > boy.powerMax)
        {
            boy.power = boy.powerMax;
        }

        self.labelPower.string = [NSString stringWithFormat:@"%d", (int32_t)(100.0f * boy.power / boy.powerMax)];
    }

    //--
    MTowerStage* stage;

    for (stage in self.stagesVisible)
    {
        [stage jumpToFrame:self.frameLocal refresh:TRUE];
    }

    //--adjust the velocity base on state
    CGPoint vO;
    CGPoint vB = CGPointMake(0.0f, 0.0f);
    CGPoint vP = boy.position;
    CGPoint vV = boy.velocity;
    CGPoint aC = boy.acceleration;

    URect boundBoy = boy.boundCollision;

    MTowerStepBase* step = boy.step;

    //--flow
    if (step)
    {
//        if (step.type == JTowerObjectTypeStepFlowLeft)
//        {
//            vB.x = -2.0f;
//        }
//        else if (step.type == JTowerObjectTypeStepFlowRight)
//        {
//            vB.x = 2.0f;
//        }
    }

    //--apply buffer

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

    if (boundBoy.left + vP.x + vV.x + vB.x < wallL)
    {
        vO.x = wallL + wallL - boundBoy.left - boundBoy.left - vP.x - vP.x - vB.x - vV.x;
        vO.y = vV.y;

        vV = CGPointMake(-vV.x, vV.y);
    }
    else if (boundBoy.right + vP.x + vV.x + vB.x > wallR)
    {
        vO.x = wallR + wallR - boundBoy.right - boundBoy.right - vP.x - vP.x - vB.x - vV.x;
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
        //--collide item
//        id<JTowerItem> item;
//
//        for (int32_t i = stageLower; i <= stageUpper; ++i)
//        {
//            item = [(JTowerStage*)self.stagesInTower[i] collideItemWithPosition:vP velocity:vO bound:boundJumper];
//
//            if (item)
//            {
//                //--post message to trigger this item and tell the match
//
//                break;
//            }
//        }

        //--collide the step
        URect boundStep = step.boundCollision;

        if ((!step.live) ||
            (vP.x + boundBoy.left  > boundStep.right) ||
            (vP.x + boundBoy.right < boundStep.left))
        {
//            if (boy.step.type == MTowerObjectTypeStepBrittle)
//            {
//                [(JTowerStepBrittle*)jumper.step dismiss];
//            }

            boy.step = nil;
        }
//        else if (step.type == MTowerObjectTypeStepRecycleVertical)
//        {
//            vO.y += boundStep.top - vP.y - boundJumper.bottom;
//        }
    }
    else
    {
        for (stage in self.stagesVisible)
        {
            step = [stage collideStepWithPosition:vP velocity:&vO bound:boundBoy];

            if (step)
            {
                break;
            }
        }

        if (step)
        {
            //--post message to land the jumper on the step

//            if (step.type == JTowerObjectTypeStepRubber)
//            {
//                vV.y = 4.0f;
//            }
//            else
            {
                boy.step = step;

                vV.y = 0.0f;
            }

            vO.x = floorf(vO.x);
        }
    }

    boy.position = ccpAdd(vP, vO);
    boy.velocity = vV;
}

//------------------------------------------------------------------------------
-(void) updateStage
{
    CGPoint p = self.boyLocal.position;

    //--check upper bound only

    MTowerStage* stage = [self.stagesInTower lastObject];

    if (p.y + 512.0f > stage.rangeCollision.lowerBound)
    {
        stage = [MTowerStage stageWithIndex:stage.stageIndex + 1
                                       seed:self.seedLarge
                                  matchGame:FALSE];

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

            [self.stagesVisible addObject:stage];
        }
    }
}

//------------------------------------------------------------------------------
-(void) updateCamera
{
    CGPoint p = self.boyLocal.position;

    self.labelPower.position = CGPointMake(p.x, p.y + 24.0f);

    self.wall.cameraPosition = p;

    p.x = 5.0f;
    p.y = 120.0f - p.y;

    self.position = p;
}

//------------------------------------------------------------------------------
-(void) updateWaterLevel
{
    float y = self.boyLocal.position.y;

    if (self.waterLevel < y - 240.0f)
    {
        self.waterLevel = y - 240.0f;

        //--destroy stages
    }
    else if (self.waterLevel > y + 22.0f)
    {
        //--game over
    }
}

//------------------------------------------------------------------------------
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    self.powerUp = TRUE;

    return TRUE;
}

//------------------------------------------------------------------------------
-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
    self.powerUp = FALSE;

    MBoyLocal* boy = self.boyLocal;

    if (/*(self.state == JTowerStatePlaying) &&*/ boy.step)
    {
        CGPoint v = boy.velocity;

        v.y = floorf(11.0f * (1.0f + boy.power / boy.powerMax));

//        if (jumper.step.type == JTowerObjectTypeStepSpring)
//        {
//            v.y += 10.0f;
//        }
//        else if (jumper.step.type == JTowerObjectTypeStepBrittle)
//        {
//            [(JTowerStepBrittle*)jumper.step dismiss];
//        }

        boy.step = nil;

        boy.velocity = v;
    }

    boy.power = 0.0f;

    self.labelPower.string = @"0";
}

//------------------------------------------------------------------------------
-(void) ccTouchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
    self.powerUp = FALSE;
}

//------------------------------------------------------------------------------
@end
