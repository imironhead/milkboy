//
//  MTowerItem.m
//  Milkboy
//
//  Created by iRonhead on 5/29/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MSpriteTowerItem.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerItemBase()
{
    struct
    {
        int32_t     live: 1;
        uint32_t    seed: 15;
        int32_t     type: 16;
        uint32_t    uiid: 32;
    } itemInfo;
}

@property (nonatomic, assign, readwrite) BOOL live;
@property (nonatomic, assign, readwrite) NSRange range;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerItemBase
//------------------------------------------------------------------------------
+(id) itemWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed
{
    id item = nil;

    switch (type)
    {
    case MTowerObjectTypeItemBox:
        {
            item = [[MSpriteTowerItemBox alloc] initWithPosition:position uiid:uiid seed:seed];
        }
        break;
    case MTowerObjectTypeItemCat:
        {
            item = [[MSpriteTowerItemCat alloc] initWithPosition:position uiid:uiid seed:seed];
        }
        break;
    case MTowerObjectTypeItemMilkAgile:
    case MTowerObjectTypeItemMilkDash:
    case MTowerObjectTypeItemMilkDoubleJump:
    case MTowerObjectTypeItemMilkGlide:
    case MTowerObjectTypeItemMilkStrength:
    case MTowerObjectTypeItemMilkStrengthExtra:
        {
            item = [[MSpriteTowerItemMilk alloc] initWithType:type position:position uiid:uiid seed:seed];
        }
        break;
    default:
        {
            NSAssert(0, @"[MTowerItemBase itemWithType: position: uiid: seed:]");
        }
        break;
    }

    return item;
}

//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed
   spriteFrameName:(NSString*)spriteFrameName
          position:(CGPoint)position
{
    self = [super initWithSpriteFrameName:spriteFrameName];

    if (self)
    {
        //--
        self.scale = 2.0f;

        self.anchorPoint = ccp(0.5f, 0.0f);

        self.position = position;

        //--
        self->itemInfo.live = 1;
        self->itemInfo.seed = seed;
        self->itemInfo.type = type;
        self->itemInfo.uiid = uiid;

        //--
        CGRect rect = self.boundingBox;

        self.range = NSMakeRange((NSUInteger)rect.origin.y, (NSUInteger)rect.size.height);
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
-(id) initWithPosition:(CGPoint)position
                  uiid:(uint32_t)uiid
                  seed:(uint32_t)seed
{
    NSAssert(0, @"[MTowerItemBase initWithType: position: uiid: seed]");

    return nil;
}

//------------------------------------------------------------------------------
-(MTowerObjectType) type
{
    return self->itemInfo.type;
}

//------------------------------------------------------------------------------
-(void) setType:(MTowerObjectType)type
{
    self->itemInfo.type = type;
}

//------------------------------------------------------------------------------
-(uint32_t) uiid
{
    return self->itemInfo.uiid;
}

//------------------------------------------------------------------------------
-(uint32_t) seed
{
    return self->itemInfo.seed;
}

//------------------------------------------------------------------------------
-(BOOL) live
{
    return (self->itemInfo.live != 0);
}

//------------------------------------------------------------------------------
-(void) setLive:(BOOL)live
{
    self->itemInfo.live = live;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{}

//------------------------------------------------------------------------------
-(void) collected
{
    self.visible = FALSE;

    self->itemInfo.live = FALSE;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerItemBox
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  uiid:(uint32_t)uiid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeItemBox
                          uiid:uiid
                          seed:seed
               spriteFrameName:@"item_box.png"
                      position:position];

    if (self)
    {
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    if (!self.live)
    {
        //--cat in box

        NSString* name = [NSString stringWithFormat:@"item_box_cat_%02d.png", (frame / 20) % 5];

        self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
}

//------------------------------------------------------------------------------
-(void) collected
{
    self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"item_box_cat_00.png"];

    self.live = FALSE;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerItemCat
//------------------------------------------------------------------------------
-(id) initWithPosition:(CGPoint)position
                  uiid:(uint32_t)uiid
                  seed:(int32_t)seed
{
    self = [super initWithType:MTowerObjectTypeItemCat
                          uiid:uiid
                          seed:seed
               spriteFrameName:@"item_cat_00.png"
                      position:position];

    if (self)
    {
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    if (self.live)
    {
        NSString* name = [NSString stringWithFormat:@"item_cat_%02d.png", (frame / 20) % 4];

        self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSpriteTowerItemMilk
//------------------------------------------------------------------------------
-(id) initWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(int32_t)seed
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

    self = [super initWithType:type
                          uiid:uiid
                          seed:seed
               spriteFrameName:frameName
                      position:position];

    if (self)
    {
    }

    return self;
}

//------------------------------------------------------------------------------
@end

