//
//  MTowerItem.m
//  Milkboy
//
//  Created by iRonhead on 5/29/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MTowerItem.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerItemBase()
{
    struct
    {
        int32_t     live: 1;
        uint32_t    seed: 15;
        int32_t     type: 16;
        uint32_t    uiid: 32;
    } stepInfo;
}

@property (nonatomic, strong, readwrite) CCSprite* sprite;
@property (nonatomic, assign, readwrite) URect boundCollision;
@property (nonatomic, assign, readwrite) BOOL live;
@end

//------------------------------------------------------------------------------
@implementation MTowerItemBase
//------------------------------------------------------------------------------
+(id) itemWithPosition:(CGPoint)position uiid:(uint32_t)uiid seed:(uint32_t)seed
{
    return [[self alloc] initWithPosition:position uiid:uiid seed:seed];
}

//------------------------------------------------------------------------------
+(id) itemWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed
{
    id step = nil;

    switch (type)
    {
    case MTowerObjectTypeItemMilk:
        {
            step = [[MTowerItemMilk alloc] initWithPosition:position uiid:uiid seed:seed];
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
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed
{
    self = [super init];

    if (self)
    {
        self->stepInfo.live = 1;
        self->stepInfo.seed = seed;
        self->stepInfo.type = type;
        self->stepInfo.uiid = uiid;
    }

    return self;
}

//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  uiid:(uint32_t)uiid
                  seed:(uint32_t)seed
{
    NSAssert(0, @"[MTowerItemBase initWithCollisionBound: uiid: seed]");

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
-(uint32_t) uiid
{
    return self->stepInfo.uiid;
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
-(void) collected
{
    self.sprite.visible = FALSE;

    self.live = FALSE;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MTowerItemMilk
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  uiid:(uint32_t)uiid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeItemMilk
                          uiid:uiid
                          seed:seed];

    if (self)
    {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"milk.png"];

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 0.0f);

        self.boundCollision = URectMake(position.x - 16.0f, position.y, position.x + 16.0f, position.y + 32.0f);
    }

    return self;
}

//------------------------------------------------------------------------------
@end

