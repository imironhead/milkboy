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


//------------------------------------------------------------------------------
@interface MLayerTower()
@property (nonatomic, strong, readwrite) MBoyLocal* boyLocal;

@property (nonatomic, assign, readwrite) float waterLevel;
@property (nonatomic, assign, readwrite) float waterSpeed;

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
        //--
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Texture/test.plist"];

        [self scheduleUpdateWithPriority:0];

        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:TRUE];

        //--
        self.seedLarge = 1 + arc4random_uniform(65534);
        self.seedSmall = self.seedLarge;

        //--initial stage
        MTowerStage* stage = [MTowerStage stageWithIndex:0 seed:0 matchGame:match != nil];

        self.stagesInTower = [NSMutableArray arrayWithObject:stage];
        self.stagesVisible = [NSMutableArray arrayWithObject:stage];

        //--boy
        self.boyLocal = [MBoyLocal new];

        [self addChild:self.boyLocal.sprite z:2];

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
                [self addChild:step.sprite z:1];
            }

            for (CCSprite* brick in stage.bricks)
            {
                [self addChild:brick z:0];
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
    int32_t stageLower = 0;
    int32_t stageUpper = 1;

    for (int32_t i = stageLower; i <= stageUpper; ++i)
    {
        [(MTowerStage*)self.stagesInTower[i] jumpToFrame:self.frameLocal refresh:TRUE];
    }

    //--adjust the velocity base on state
    UVector2 vO;
    UVector2 vB = UVector2Make(0.0f, 0.0f);
    UVector2 vP = boy.position;
    UVector2 vV = boy.velocity;
    UVector2 aC = boy.acceleration;

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
    float wallL = 5.0f;
    float wallR = 315.0f;

    if (boundBoy.left + vP.x + vV.x + vB.x < wallL)
    {
        vO.x = wallL + wallL - boundBoy.left - boundBoy.left - vP.x - vP.x - vB.x - vV.x;
        vO.y = vV.y;

        vV = UVector2Make(-vV.x, vV.y);
    }
    else if (boundBoy.right + vP.x + vV.x + vB.x > wallR)
    {
        vO.x = wallR + wallR - boundBoy.right - boundBoy.right - vP.x - vP.x - vB.x - vV.x;
        vO.y = vV.y;

        vV = UVector2Make(-vV.x, vV.y);
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
        for (int32_t i = stageLower; i <= stageUpper; ++i)
        {
            step = [(MTowerStage*)self.stagesInTower[i] collideStepWithPosition:vP velocity:&vO bound:boundBoy];

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

    boy.position = UVector2Add(vP, vO);
    boy.velocity = vV;
}

//------------------------------------------------------------------------------
-(void) updateCamera
{
    CGPoint p = UVector2ToCGPoint(self.boyLocal.position);

    self.labelPower.position = CGPointMake(p.x, p.y + 24.0f);

    p.x = 0.0f;
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
        UVector2 v = boy.velocity;

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
