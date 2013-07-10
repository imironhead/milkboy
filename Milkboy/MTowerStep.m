//
//  MTowerStep.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MTowerStep.h"


//------------------------------------------------------------------------------
@interface MTowerStepBase()
{
    struct
    {
        int32_t     live: 1;
        uint32_t    seed: 15;
        int32_t     type: 16;
        uint32_t    usid: 32;
    } stepInfo;
}

@property (nonatomic, strong, readwrite) CCSprite* sprite;
@property (nonatomic, assign, readwrite) CGRect boundCollision;
@property (nonatomic, assign, readwrite) BOOL live;
@end

//------------------------------------------------------------------------------
@implementation MTowerStepBase
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
            step = [[MTowerStepBasement alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepBrittle:
        {
            step = [[MTowerStepBrittle alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepDrift:
        {
            step = [[MTowerStepDrift alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepMoveLeft:
    case MTowerObjectTypeStepMoveRight:
        {
            step = [[MTowerStepMove alloc] initWithType:type
                                               position:position
                                                   usid:usid
                                                   seed:seed];
        }
        break;
    case MTowerObjectTypeStepMovingWalkwayLeft:
    case MTowerObjectTypeStepMovingWalkwayRight:
        {
            step = [[MTowerStepMovingWalkway alloc] initWithType:type
                                                        position:position
                                                            usid:usid
                                                            seed:seed];
        }
        break;
    case MTowerObjectTypeStepPatrolHorizontal:
    case MTowerObjectTypeStepPatrolVertical:
        {
            step = [[MTowerStepPatrol alloc] initWithType:type
                                                 position:position
                                                     usid:usid
                                                     seed:seed];
        }
        break;
    case MTowerObjectTypeStepPulse:
        {
            step = [[MTowerStepPulse alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepSpring:
        {
            step = [[MTowerStepSpring alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepStation:
        {
            step = [[MTowerStepStation alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    case MTowerObjectTypeStepSteady:
        {
            step = [[MTowerStepSteady alloc] initWithPosition:position usid:usid seed:seed];
        }
        break;
    default:
        {
            NSAssert(0, @"[MTowerStepBase stepWithType: position: usid: seed:]");
        }
        break;
    }

    return step;
}

//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
              usid:(uint32_t)usid
              seed:(uint32_t)seed
{
    self = [super init];

    if (self)
    {
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
    NSAssert(0, @"[MTowerStepBase initWithType: position: usid: seed]");

    return nil;
}

//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(uint32_t)seed
{
    NSAssert(0, @"[MTowerStepBase initWithPosition: usid: seed]");

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
-(MCollisionRange) rangeVisiblity
{
    return MCollisionRangeMake(
        CGRectGetMinY(self->_boundCollision),
        CGRectGetMaxY(self->_boundCollision));
}

//------------------------------------------------------------------------------
-(MCollisionRange) rangeCollision
{
    return MCollisionRangeMake(
        CGRectGetMinY(self->_boundCollision),
        CGRectGetMaxY(self->_boundCollision));
}

//------------------------------------------------------------------------------
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh
{}

//------------------------------------------------------------------------------
-(void) boyJump:(MBoy*)boy
{}

//------------------------------------------------------------------------------
-(void) boyLand:(MBoy*)boy
{}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MTowerStepBasement
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepBasement
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_steady.png"];

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.sprite.scaleX = 10.0f;

        self.sprite.visible = FALSE;

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerStepBrittle()
@property (nonatomic, assign) int32_t counter;
@end

//------------------------------------------------------------------------------
@implementation MTowerStepBrittle
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepSteady
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_disposable_01.png"];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;

        self.counter = 0;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) boyJump:(MBoy*)boy
{
    self.counter += 1;

    if (self.counter > 2)
    {
        self.live = FALSE;

        self.sprite.visible = FALSE;
    }
    else
    {
        NSString* name = [NSString stringWithFormat:@"step_disposable_%02d.png", self.counter + 1];

        self.sprite.displayFrame =
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MTowerStepDrift
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepDrift
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_bubble.png"];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerStepMove()
@property (nonatomic, assign) BOOL moveRight;
@property (nonatomic, assign) CGPoint positionOrigin;
@end

//------------------------------------------------------------------------------
@implementation MTowerStepMove
//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(int32_t)seed
{
    NSAssert(
        (type == MTowerObjectTypeStepMoveLeft) || (type == MTowerObjectTypeStepMoveRight),
        @"[MTowerStepMove initWithType: collisionBound: usid: seed:]");

    self = [super initWithType:type
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.moveRight = (type == MTowerObjectTypeStepMoveRight);

        self.positionOrigin = position;

        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_steady.png"];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh
{
    int32_t w = self.sprite.boundingBox.size.width;

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

    self.sprite.position = p;

    self.boundCollision = self.sprite.boundingBox;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerStepMovingWalkway()
@property (nonatomic, strong) NSArray* frames;
@property (nonatomic, assign) BOOL moveRight;
@end

//------------------------------------------------------------------------------
@implementation MTowerStepMovingWalkway
//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(int32_t)seed
{
    NSAssert(
        (type == MTowerObjectTypeStepMovingWalkwayLeft) || (type == MTowerObjectTypeStepMovingWalkwayRight),
        @"[MTowerStepMove initWithType: collisionBound: usid: seed:]");

    self = [super initWithType:type
                          usid:usid
                          seed:seed];

    if (self)
    {
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];

        self.frames =
        @[
            [cache spriteFrameByName:@"step_scroll_01.png"],
            [cache spriteFrameByName:@"step_scroll_02.png"],
            [cache spriteFrameByName:@"step_scroll_03.png"],
        ];

        self.moveRight = (type == MTowerObjectTypeStepMovingWalkwayRight);

        self.sprite = [CCSprite spriteWithSpriteFrame:self.frames[0]];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh
{
    uint32_t k = frame % self.frames.count;

    if (!self.moveRight)
    {
        k = self.frames.count - k - 1;
    }

    self.sprite.displayFrame = self.frames[k];
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerStepPatrol()
@property (nonatomic, assign) BOOL moveHorizontal;
@property (nonatomic, assign) CGPoint positionOrigin;
@end

//------------------------------------------------------------------------------
@implementation MTowerStepPatrol
//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(int32_t)seed
{
    NSAssert(
        (type == MTowerObjectTypeStepPatrolHorizontal) || (type == MTowerObjectTypeStepPatrolVertical),
        @"[MTowerStepPatrol initWithType: collisionBound: usid: seed:]");

    self = [super initWithType:type
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.moveHorizontal = (type == MTowerObjectTypeStepPatrolHorizontal);

        self.positionOrigin = position;

        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_steady.png"];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh
{
    CGPoint p = self.positionOrigin;

    if (self.moveHorizontal)
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

    self.sprite.position = p;

    self.boundCollision = self.sprite.boundingBox;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MTowerStepPulse
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepPulse
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_pulse_on.png"];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh
{
    frame = (frame + (self.usid & 0xff)) % 75;

    self.live = (frame < 60);

    if (frame < 60)
    {
        self.sprite.opacity = 0xff - frame * 4;
    }
    else
    {
        self.sprite.opacity = 0xff;
    }
}

//------------------------------------------------------------------------------
-(void) setLive:(BOOL)live
{
    if (self.live != live)
    {
        [super setLive:live];

        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];

        self.sprite.displayFrame = [cache spriteFrameByName:live ? @"step_pulse_on.png" : @"step_pulse_off.png"];
    }
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MTowerStepSpring
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepSpring
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_spring.png"];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MTowerStepStation
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepStation
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_steady.png"];

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.sprite.scaleX = 10.0f;

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MTowerStepSteady
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  usid:(uint32_t)usid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepSteady
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step_steady.png"];

        self.sprite.scale = 2.0f;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 1.0f);

        self.boundCollision = self.sprite.boundingBox;
    }

    return self;
}

//------------------------------------------------------------------------------
@end
