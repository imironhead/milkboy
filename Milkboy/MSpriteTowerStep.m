//
//  MSpriteTowerStep.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MSpriteTowerStep.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerStep ()
@property (nonatomic, strong, readwrite) NSNumber* parameter;
@property (nonatomic, assign, readwrite) MTowerObjectType type;
@property (nonatomic, assign, readwrite) BOOL live;
@property (nonatomic, assign, readwrite) NSRange range;
@property (nonatomic, assign) CGPoint originPosition;
@property (nonatomic, assign) SEL selectorUpdateToFrame;
@property (nonatomic, assign) SEL selectorBoyJump;
@property (nonatomic, assign) SEL selectorBoyLand;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerStep
//------------------------------------------------------------------------------
static NSMutableArray* freeSteps = nil;
static NSMutableArray* freeSprites = nil;

//------------------------------------------------------------------------------
+(id) factoryCreateStepWithType:(MTowerObjectType)type position:(CGPoint)position
{
    MSpriteTowerStep* step = nil;

    if (freeSteps && freeSteps.lastObject)
    {
        step = freeSteps.lastObject;

        [freeSteps removeLastObject];
    }
    else
    {
        step = [MSpriteTowerStep new];
    }

    NSString* displayFrameName = nil;

    step.type = type;
    step.live = TRUE;
    step.flipX = FALSE;
    step.scale = 2.0f;
    step.visible = TRUE;
    step.position = position;
    step.anchorPoint = ccp(0.5f, 1.0f);

    switch (type)
    {
    case MTowerObjectTypeStepBasement:
        {
            displayFrameName = @"step_steady.png";

            step.scale = 10.0f;
            step.visible = FALSE;

            step.selectorUpdateToFrame = @selector(updateToFrameNormal:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepAbsorb:
        {
            //--jump lower

            displayFrameName = @"step_absorb.png";

            step.selectorUpdateToFrame = @selector(updateToFrameNormal:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepDisposable:
        {
            displayFrameName = @"step_disposable_01.png";

            step.parameter = @0;

            step.selectorUpdateToFrame = @selector(updateToFrameNormal:);
            step.selectorBoyJump = @selector(boyJumpStepDisposable:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepDrift:
        {
            //--can not jump

            displayFrameName = @"step_drift.png";

            step.selectorUpdateToFrame = @selector(updateToFrameNormal:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepMoveLeft:
    case MTowerObjectTypeStepMoveRight:
        {
            displayFrameName = @"step_steady.png";

            step.selectorUpdateToFrame = @selector(updateToFrameStepMove:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);

            step.originPosition = position;
        }
        break;
    case MTowerObjectTypeStepMovingWalkwayLeft:
    case MTowerObjectTypeStepMovingWalkwayRight:
        {
            displayFrameName = @"step_moving_walkway_01.png";

            if (type == MTowerObjectTypeStepMovingWalkwayLeft)
            {
                step.flipX = TRUE;
            }

            step.selectorUpdateToFrame = @selector(updateToFrameStepMovingWalkway:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepPatrolHorizontal:
    case MTowerObjectTypeStepPatrolVertical:
        {
            displayFrameName = @"step_steady.png";

            step.originPosition = position;

            if (type == MTowerObjectTypeStepPatrolVertical)
            {
                step.parameter = [NSNumber numberWithInt:arc4random_uniform(80)];

                CGRect rect = step.boundingBox;

                step.range = NSMakeRange(
                    position.y - 40.0f - rect.size.height,
                    80.0f + rect.size.height);
            }
            else
            {
                step.parameter = [NSNumber numberWithInt:arc4random_uniform(120)];
            }

            step.selectorUpdateToFrame = @selector(updateToFrameStepPatrol:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepPulse:
        {
            displayFrameName = @"step_pulse_off.png";

            CCSprite* spriteOff;

            if (freeSprites && freeSprites.lastObject)
            {
                spriteOff = freeSprites.lastObject;

                [freeSprites removeLastObject];
            }
            else
            {
                spriteOff = [CCSprite spriteWithSpriteFrameName:@"step_pulse_on.png"];
            }

            spriteOff.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"step_pulse_on.png"];

            spriteOff.tag = 0xcdcdcdcd;
            spriteOff.position = ccp(0.0f, 0.0f);
            spriteOff.anchorPoint = ccp(0.0f, 0.0f);

            [step addChild:spriteOff z:-1];

            step.parameter = [NSNumber numberWithInt:arc4random_uniform(255)];

            step.selectorUpdateToFrame = @selector(updateToFrameStepPulse:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepSpring:
        {
            displayFrameName = @"step_spring.png";

            step.selectorUpdateToFrame = @selector(updateToFrameNormal:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepSpringChargeAuto:
        {
            displayFrameName = @"step_spring_charge_auto_00.png";

            step.parameter = @0;

            step.selectorUpdateToFrame = @selector(updateToFrameStepSpringChargeAuto:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    case MTowerObjectTypeStepSteady:
        {
            displayFrameName = @"step_steady.png";

            step.selectorUpdateToFrame = @selector(updateToFrameNormal:);
            step.selectorBoyJump = @selector(boyJumpNormal:);
            step.selectorBoyLand = @selector(boyLandNormal:);
        }
        break;
    default:
        {
            NSAssert(0, @"[MSpriteTowerStep factoryCreateStepWithType: position:]");
        }
        break;
    }

    step.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:displayFrameName];

    //--
    if (type != MTowerObjectTypeStepPatrolVertical)
    {
        CGRect rect = step.boundingBox;

        step.range = NSMakeRange((NSUInteger)rect.origin.y, (NSUInteger)rect.size.height);
    }

    return step;
}

//------------------------------------------------------------------------------
+(void) factoryDeleteStep:(MSpriteTowerStep*)step
{
    if (!freeSteps)
    {
        freeSteps = [NSMutableArray array];
    }

    if (!freeSprites)
    {
        freeSprites = [NSMutableArray array];
    }

    for (CCSprite* sprite in step.children)
    {
        [freeSprites addObject:sprite];
    }

    [step removeAllChildrenWithCleanup:TRUE];

    [freeSteps addObject:step];
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:self.selectorUpdateToFrame withObject:[NSNumber numberWithInt:frame]];
#pragma clang diagnostic pop
}

//------------------------------------------------------------------------------
-(void) boyJump:(MLayerTowerBoy*)boy
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:self.selectorBoyJump withObject:boy];
#pragma clang diagnostic pop
}

//------------------------------------------------------------------------------
-(void) boyLand:(MLayerTowerBoy*)boy
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:self.selectorBoyLand withObject:boy];
#pragma clang diagnostic pop
}

//------------------------------------------------------------------------------
-(void) updateToFrameNormal:(NSNumber*)frame
{}

//------------------------------------------------------------------------------
-(void) updateToFrameStepMove:(NSNumber*)frame
{
    int32_t w = self.boundingBox.size.width;

    CGPoint p = self.position;

    int32_t dx;

    if (self.type == MTowerObjectTypeStepMoveRight)
    {
        dx = 2 * frame.intValue + (w / 2) + (int32_t)self.originPosition.x;
    }
    else
    {
        dx = (w + 308) * frame.intValue + (w / 2) + (int32_t)self.originPosition.x;
    }

    p.x = (dx % (310 + w)) - (w / 2);

    self.position = p;
}

//------------------------------------------------------------------------------
-(void) updateToFrameStepMovingWalkway:(NSNumber*)frame
{
    uint32_t k = frame.intValue % 3;

    NSString* displayFrameName =
        [NSString stringWithFormat:@"step_moving_walkway_%02d.png", k + 1];

    self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:displayFrameName];
}

//------------------------------------------------------------------------------
-(void) updateToFrameStepPatrol:(NSNumber*)frame
{
    CGPoint p = self.originPosition;

    if (self.type == MTowerObjectTypeStepPatrolHorizontal)
    {
        int32_t dx = (60 + self.parameter.intValue + 2 * frame.intValue) % 240;

        if (dx > 120)
        {
            dx = 240 - dx;
        }

        p.x += (float)(dx - 60);
    }
    else
    {
        int32_t dy = (40 + self.parameter.intValue + 2 * frame.intValue) % 160;

        if (dy > 80)
        {
            dy = 160 - dy;
        }

        p.y += (float)(dy - 40);
    }

    self.position = p;
}

//------------------------------------------------------------------------------
-(void) updateToFrameStepPulse:(NSNumber*)frame
{
    int32_t k = (frame.intValue + self.parameter.intValue) % 75;

    CCSprite* sprite = (CCSprite*)[self getChildByTag:0xcdcdcdcd];

    self.live = (k < 60);

    sprite.visible = self.live;

    sprite.opacity = (self.live ? 0xff - k * 4 : 0xff);
}

//------------------------------------------------------------------------------
-(void) updateToFrameStepSpringChargeAuto:(NSNumber*)frame
{
    int32_t token = (int32_t)self.position.x;

    int32_t k = ((frame.intValue + token) % 30) / 5;

    if (self.parameter.intValue != k)
    {
        self.parameter = [NSNumber numberWithInt:k];

        self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
            [NSString stringWithFormat:@"step_spring_charge_auto_%02d.png", k]];
    }
}

//------------------------------------------------------------------------------
-(void) boyJumpNormal:(MLayerTowerBoy*)boy
{}

//------------------------------------------------------------------------------
-(void) boyJumpStepDisposable:(MLayerTowerBoy*)boy
{
    self.parameter = [NSNumber numberWithInt:self.parameter.intValue + 1];

    if (self.parameter.intValue > 2)
    {
        self.live = FALSE;

        self.visible = FALSE;
    }
    else
    {
        NSString* name = [NSString stringWithFormat:@"step_disposable_%02d.png", self.parameter.intValue + 1];

        self.displayFrame =
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
}

//------------------------------------------------------------------------------
-(void) boyLandNormal:(MLayerTowerBoy*)boy
{}

//------------------------------------------------------------------------------
@end

