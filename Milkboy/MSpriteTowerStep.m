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
@interface MSpriteTowerStepBase()
{
    struct
    {
        int32_t     live: 1;
        uint32_t    seed: 15;
        int32_t     type: 16;
        uint32_t    usid: 32;
    } stepInfo;
}

@property (nonatomic, assign, readwrite) BOOL live;
@property (nonatomic, assign, readwrite) NSRange range;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerStepBase
//------------------------------------------------------------------------------
+(id) stepWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(uint32_t)seed
{
    id step = nil;

    switch (type)
    {
    case MTowerObjectTypeStepBasement:
        {
            step = [[MSpriteTowerStepBasement alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepBrittle:
        {
            step = [[MSpriteTowerStepBrittle alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepDrift:
        {
            step = [[MSpriteTowerStepDrift alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepMoveLeft:
    case MTowerObjectTypeStepMoveRight:
        {
            step = [[MSpriteTowerStepMove alloc] initWithType:type
                                               position:position
                                                   usid:usid
                                                   seed:seed];
        }
        break;
    case MTowerObjectTypeStepMovingWalkwayLeft:
    case MTowerObjectTypeStepMovingWalkwayRight:
        {
            step = [[MSpriteTowerStepMovingWalkway alloc] initWithType:type
                                                        position:position
                                                            usid:usid
                                                            seed:seed];
        }
        break;
    case MTowerObjectTypeStepPatrolHorizontal:
    case MTowerObjectTypeStepPatrolVertical:
        {
            step = [[MSpriteTowerStepPatrol alloc] initWithType:type
                                                 position:position
                                                     usid:usid
                                                     seed:seed];
        }
        break;
    case MTowerObjectTypeStepPulse:
        {
            step = [[MSpriteTowerStepPulse alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepSpring:
        {
            step = [[MSpriteTowerStepSpring alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepStation:
        {
            step = [[MSpriteTowerStepStation alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepSteady:
        {
            step = [[MSpriteTowerStepSteady alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    default:
        {
            NSAssert(0, @"[MSpriteTowerStepBase stepWithType: position: usid: seed:]");
        }
        break;
    }

    return step;
}

//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
              usid:(uint32_t)usid
              seed:(uint32_t)seed
   spriteFrameName:(NSString*)spriteFramename
          position:(CGPoint)position
{
    self = [super initWithSpriteFrameName:spriteFramename];

    if (self)
    {
        //
        self.position = position;

        self.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.scale = 2.0f;

        //--
        CGRect rect = self.boundingBox;

        self.range = NSMakeRange((NSUInteger)rect.origin.y, (NSUInteger)rect.size.height);

        //
        self->stepInfo.live = 1;
        self->stepInfo.seed = seed;
        self->stepInfo.type = type;
        self->stepInfo.usid = usid;
    }

    return self;
}

//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(int32_t)seed
{
    NSAssert(0, @"[MSpriteTowerStepBase initWithType: position: usid: seed]");

    return nil;
}

//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(uint32_t)seed
{
    NSAssert(0, @"[MSpriteTowerStepBase initWithPosition: usid: seed]");

    return nil;
}

//------------------------------------------------------------------------------
-(MTowerObjectType) type
{
    return self->stepInfo.type;
}

//------------------------------------------------------------------------------
-(void) setType:(MTowerObjectType)type
{
    self->stepInfo.type = type;
}

//------------------------------------------------------------------------------
-(uint32_t) usid
{
    return self->stepInfo.usid;
}

//------------------------------------------------------------------------------
-(uint32_t) seed
{
    return self->stepInfo.seed;
}

//------------------------------------------------------------------------------
-(BOOL) live
{
    return (self->stepInfo.live != 0);
}

//------------------------------------------------------------------------------
-(void) setLive:(BOOL)live
{
    self->stepInfo.live = live;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{}

//------------------------------------------------------------------------------
-(void) boyJump:(MLayerTowerBoy*)boy
{}

//------------------------------------------------------------------------------
-(void) boyLand:(MLayerTowerBoy*)boy
{}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerStepBasement
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepBasement
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_steady.png"
                      position:position];

    if (self)
    {
        self.scale = 10.0f;

        self.visible = FALSE;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerStepBrittle()
@property (nonatomic, assign) int32_t counter;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerStepBrittle
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepSteady
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_disposable_01.png"
                      position:position];

    if (self)
    {
        self.counter = 0;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) boyJump:(MLayerTowerBoy*)boy
{
    self.counter += 1;

    if (self.counter > 2)
    {
        self.live = FALSE;

        self.visible = FALSE;
    }
    else
    {
        NSString* name = [NSString stringWithFormat:@"step_disposable_%02d.png", self.counter + 1];

        self.displayFrame =
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerStepDrift
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepDrift
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_bubble.png"
                      position:position];

    if (self)
    {
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerStepMove()
@property (nonatomic, assign) BOOL moveRight;
@property (nonatomic, assign) CGPoint positionOrigin;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerStepMove
//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(int32_t)seed
{
    NSAssert(
        (type == MTowerObjectTypeStepMoveLeft) || (type == MTowerObjectTypeStepMoveRight),
        @"[MSpriteTowerStepMove initWithType: collisionBound: usid: seed:]");

    self = [super initWithType:type
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_steady.png"
                      position:position];

    if (self)
    {
        self.moveRight = (type == MTowerObjectTypeStepMoveRight);

        self.positionOrigin = position;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    int32_t w = self.boundingBox.size.width;

    CGPoint p = self.positionOrigin;

    int32_t dx;

    if (self.moveRight)
    {
        dx = 2 * frame + (w / 2) + (int32_t)p.x;
    }
    else
    {
        dx = (w + 308) * frame + (w / 2) + (int32_t)p.x;
    }

    p.x = (dx % (310 + w)) - (w / 2);

    self.position = p;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerStepMovingWalkway()
@property (nonatomic, strong) NSArray* frames;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerStepMovingWalkway
//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(int32_t)seed
{
    NSAssert(
        (type == MTowerObjectTypeStepMovingWalkwayLeft) || (type == MTowerObjectTypeStepMovingWalkwayRight),
        @"[MSpriteTowerStepMove initWithType: collisionBound: usid: seed:]");

    self = [super initWithType:type
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_scroll_01.png"
                      position:position];

    if (self)
    {
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];

        self.frames =
        @[
            [cache spriteFrameByName:@"step_scroll_01.png"],
            [cache spriteFrameByName:@"step_scroll_02.png"],
            [cache spriteFrameByName:@"step_scroll_03.png"],
        ];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    uint32_t k = frame % self.frames.count;

    if (self.type != MTowerObjectTypeStepMovingWalkwayRight)
    {
        k = self.frames.count - k - 1;
    }

    self.displayFrame = self.frames[k];
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerStepPatrol()
@property (nonatomic, assign) CGPoint positionOrigin;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerStepPatrol
//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(int32_t)seed
{
    NSAssert(
        (type == MTowerObjectTypeStepPatrolHorizontal) || (type == MTowerObjectTypeStepPatrolVertical),
        @"[MSpriteTowerStepPatrol initWithType: collisionBound: usid: seed:]");

    self = [super initWithType:type
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_steady.png"
                      position:position];

    if (self)
    {
        self.positionOrigin = position;

        if (type == MTowerObjectTypeStepPatrolVertical)
        {
            CGRect rect = self.boundingBox;

            self.range = NSMakeRange(
                position.y - 40.0f - rect.size.height,
                80.0f + rect.size.height);
        }
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    CGPoint p = self.positionOrigin;

    if (self.type == MTowerObjectTypeStepPatrolHorizontal)
    {
        int32_t dx = (60 + 2 * frame) % 240;

        if (dx > 120)
        {
            dx = 240 - dx;
        }

        p.x += (float)(dx - 60);
    }
    else
    {
        int32_t dy = (40 + 2 * frame) % 160;

        if (dy > 80)
        {
            dy = 160 - dy;
        }

        p.y += (float)(dy - 40);
    }

    self.position = p;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerStepPulse
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepPulse
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_pulse_off.png"
                      position:position];

    if (self)
    {
        CCSprite* spriteOff = [CCSprite spriteWithSpriteFrameName:@"step_pulse_on.png"];

        spriteOff.tag = 0xcdcdcdcd;

        spriteOff.position = ccp(0.0f, 0.0f);
        spriteOff.anchorPoint = ccp(0.0f, 0.0f);

        [self addChild:spriteOff z:-1];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    frame = (frame + (self.usid & 0xff)) % 75;

    self.live = (frame < 60);

    if (frame < 60)
    {
        [(CCSprite*)[self getChildByTag:0xcdcdcdcd] setOpacity:0xff - frame * 4];
    }
    else
    {
        [(CCSprite*)[self getChildByTag:0xcdcdcdcd] setOpacity:0xff];
    }
}

//------------------------------------------------------------------------------
-(void) setLive:(BOOL)live
{
    if (self.live != live)
    {
        [super setLive:live];

        [[self getChildByTag:0xcdcdcdcd] setVisible:live];
    }
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerStepSpring
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepSpring
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_spring.png"
                      position:position];

    if (self)
    {
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerStepStation
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepStation
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_steady.png"
                      position:position];

    if (self)
    {
        self.scaleX = 10.0f;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerStepSteady
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepSteady
                          usid:usid
                          seed:seed
               spriteFrameName:@"step_steady.png"
                      position:position];

    if (self)
    {
    }

    return self;
}

//------------------------------------------------------------------------------
@end
