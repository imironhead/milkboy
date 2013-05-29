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
@property (nonatomic, assign, readwrite) URect boundCollision;
@property (nonatomic, assign, readwrite) BOOL live;
@end

//------------------------------------------------------------------------------
@implementation MTowerStepBase
//------------------------------------------------------------------------------
+(id) stepWithCollisionBound:(URect)bound usid:(uint32_t)usid seed:(uint32_t)seed
{
    return [[self alloc] initWithCollisionBound:bound usid:usid seed:seed];
}

//------------------------------------------------------------------------------
+(id) stepWithType:(MTowerObjectType)type
    collisionBound:(URect)bound
              usid:(uint32_t)usid
              seed:(uint32_t)seed
{
    id step = nil;

    switch (type)
    {
    case MTowerObjectTypeStepSteady:
        {
            step = [[MTowerStepSteady alloc] initWithCollisionBound:bound usid:usid seed:seed];
        }
        break;
    default:
        {
            NSAssert(0, @"[MTowerStepBase stepWithType: collisionBound: usid: seed:]");
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
-(id) initWithCollisionBound:(URect)bound
                        usid:(uint32_t)usid
                        seed:(uint32_t)seed
{
    NSAssert(0, @"[MTowerStepBase initWithCollisionBound: usid: seed]");

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
    URect bound = self.boundCollision;

    return MCollisionRangeMake(
        bound.bottom,
        bound.top);
}

//------------------------------------------------------------------------------
-(MCollisionRange) rangeCollision
{
    URect bound = self.boundCollision;

    return MCollisionRangeMake(
        bound.bottom,
        bound.top);
}

//------------------------------------------------------------------------------
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh
{}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
@implementation MTowerStepSteady
//------------------------------------------------------------------------------
-(id) initWithCollisionBound:(URect)bound
                        usid:(uint32_t)usid
                        seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeStepSteady
                          usid:usid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"step.png"];

        self.sprite.position = CGPointMake(
            0.5f * (bound.left + bound.right),
            0.5f * (bound.bottom + bound.top));

        self.boundCollision = bound;
    }

    return self;
}

//------------------------------------------------------------------------------
@end