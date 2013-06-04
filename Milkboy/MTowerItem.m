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
@property (nonatomic, assign, readwrite) CGRect boundCollision;
@property (nonatomic, assign, readwrite) BOOL live;
@end

//------------------------------------------------------------------------------
@implementation MTowerItemBase
//------------------------------------------------------------------------------
+(id) itemWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed
{
    id step = nil;

    switch (type)
    {
    case MTowerObjectTypeItemMilkAgile:
    case MTowerObjectTypeItemMilkDash:
    case MTowerObjectTypeItemMilkDoubleJump:
    case MTowerObjectTypeItemMilkGlide:
    case MTowerObjectTypeItemMilkStrength:
    case MTowerObjectTypeItemMilkStrengthExtra:
        {
            step = [[MTowerItemMilk alloc] initWithType:type position:position uiid:uiid seed:seed];
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
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed
{
    NSAssert(0, @"[MTowerItemBase initWithType: position: uiid: seed]");

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
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(int32_t)seed
{
    self = [super initWithType:type
                          uiid:uiid
                          seed:seed];

    if (self)
    {
        NSString* frameName = @"item_milk_strength.png";

        switch (type)
        {
        case MTowerObjectTypeItemMilkAgile:
            {
                frameName = @"item_milk_agile.png";
            }
            break;
        case MTowerObjectTypeItemMilkDash:
            {
                frameName = @"item_milk_dash.png";
            }
            break;
        case MTowerObjectTypeItemMilkDoubleJump:
            {
                frameName = @"item_milk_double_jump.png";
            }
            break;
        case MTowerObjectTypeItemMilkGlide:
            {
                frameName = @"item_milk_glide.png";
            }
            break;
        case MTowerObjectTypeItemMilkStrength:
            {
                frameName = @"item_milk_strength.png";
            }
            break;
        case MTowerObjectTypeItemMilkStrengthExtra:
            {
                frameName = @"item_milk_strength_extra.png";
            }
            break;
        default:
            {
                NSAssert(0, @"[MTowerItemMilk initWithType: position: uiid: seed:]");
            }
            break;
        }

        self.sprite = [CCSprite spriteWithSpriteFrameName:frameName];

        CGSize size = self.sprite.boundingBox.size;

        self.sprite.position = position;

        self.sprite.anchorPoint = CGPointMake(0.5f, 0.0f);

        self.boundCollision = CGRectMake(
            position.x - 0.5f * size.width,
            position.y,
            size.width,
            size.height);
    }

    return self;
}

//------------------------------------------------------------------------------
@end

