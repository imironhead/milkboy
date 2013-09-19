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
@interface MSpriteTowerItem ()
@property (nonatomic, assign, readwrite) MTowerObjectType type;
@property (nonatomic, assign, readwrite) BOOL live;
@property (nonatomic, assign, readwrite) NSRange range;
@property (nonatomic, assign, readwrite) uint32_t parameter;
@property (nonatomic, assign) SEL selectorUpdateToFrame;
@property (nonatomic, assign) SEL selectorCollectedWithFlag;
@end

//------------------------------------------------------------------------------
@implementation MSpriteTowerItem
//------------------------------------------------------------------------------
static NSMutableArray* freeItems = nil;

//------------------------------------------------------------------------------
+(id) factoryCreateItemWithType:(MTowerObjectType)type position:(CGPoint)position
{
    MSpriteTowerItem* item = nil;

    if (freeItems && [freeItems count])
    {
        item = [freeItems lastObject];

        [freeItems removeLastObject];
    }
    else
    {
        item = [MSpriteTowerItem new];
    }

    NSString* displayFrameName = nil;

    item.type = type;
    item.live = TRUE;
    item.visible = TRUE;
    item.position = position;
    item.anchorPoint = ccp(0.5f, 0.0f);

    switch (type)
    {
    case MTowerObjectTypeItemBombBig:
        {
            displayFrameName = @"item_bomb_big_00.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemBombSmall:
        {
            displayFrameName = @"item_bomb_small_00.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemCat:
        {
            displayFrameName = @"item_cat_00_lying_00.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(catUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemCatBox:
        {
            displayFrameName = @"item_catbox.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(catBoxUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(catBoxCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemCoinGold:
        {
            displayFrameName = @"item_coin_00.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(coinUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemCollectionMilk_00:
    case MTowerObjectTypeItemCollectionMilk_01:
    case MTowerObjectTypeItemCollectionMilk_02:
    case MTowerObjectTypeItemCollectionMilk_03:
    case MTowerObjectTypeItemCollectionMilk_04:
    case MTowerObjectTypeItemCollectionMilk_05:
        {
            displayFrameName = [NSString stringWithFormat:
                @"item_milk_%02d.png",
                type - MTowerObjectTypeItemCollectionMilk_00];

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemDog:
        {
            displayFrameName = @"item_dog_00_lying_00.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(dogUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemDogHouse:
        {
            displayFrameName = @"item_doghouse.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(dogHouseUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(dogHouseCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemQuestionMark:
        {
            displayFrameName = @"item_chest_locked.png";

            item.scale = 2.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);

            item.parameter = MTowerObjectTypeItemBase + arc4random_uniform(MTowerObjectTypeItemMax - MTowerObjectTypeItemBase - 1);

            if (item.parameter >= MTowerObjectTypeItemQuestionMark)
            {
                item.parameter += 1;
            }
        }
        break;
    case MTowerObjectTypeItemSuitAstronaut:
        {
            displayFrameName = @"item_suit_astronaut_00.png";

            item.scale = 1.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemSuitCEO:
        {
            displayFrameName = @"item_suit_magician_00.png";

            item.scale = 1.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemSuitCommoner:
        {
            displayFrameName = @"item_suit_commoner_00.png";

            item.scale = 1.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemSuitFootballPlayer:
        {
            displayFrameName = @"item_suit_footballplayer_00.png";

            item.scale = 1.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemSuitNinja:
        {
            displayFrameName = @"item_suit_ninja_00.png";

            item.scale = 1.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    case MTowerObjectTypeItemSuitSuperhero:
        {
            displayFrameName = @"item_suit_superhero_00.png";

            item.scale = 1.0f;
            item.selectorUpdateToFrame = @selector(itemUpdateToFrame:);
            item.selectorCollectedWithFlag = @selector(itemCollectedWithFlag:);
        }
        break;
    default:
        break;
    }

    item.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:displayFrameName];

    //--
    CGRect rect = item.boundingBox;

    item.range = NSMakeRange((NSUInteger)rect.origin.y, (NSUInteger)rect.size.height);

    return item;
}

//------------------------------------------------------------------------------
+(void) factoryDeleteItem:(MSpriteTowerItem*)item
{
    if (!freeItems)
    {
        freeItems = [NSMutableArray array];
    }

    [freeItems addObject:item];
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
-(void) catUpdateToFrame:(NSNumber*)frame
{
    if (self.live)
    {
        NSString* name = [NSString stringWithFormat:@"item_cat_00_lying_%02d.png", (frame.intValue / 20) % 4];

        self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
}

//------------------------------------------------------------------------------
-(void) catBoxUpdateToFrame:(NSNumber*)frame
{
    if (!self.live)
    {
        //--cat in box

        NSString* name = [NSString stringWithFormat:@"item_catbox_cat_00_%02d.png", (frame.intValue / 20) % 5];

        self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
}

//------------------------------------------------------------------------------
-(void) coinUpdateToFrame:(NSNumber*)frame
{
    if (self.live)
    {}
}

//------------------------------------------------------------------------------
-(void) dogUpdateToFrame:(NSNumber*)frame
{
    if (self.live)
    {
    }
}

//------------------------------------------------------------------------------
-(void) dogHouseUpdateToFrame:(NSNumber*)frame
{
    if (!self.live)
    {
    }
}

//------------------------------------------------------------------------------
-(void) itemUpdateToFrame:(NSNumber*)frame
{
}

//------------------------------------------------------------------------------
-(void) collectedWithFlag:(NSNumber*)flag
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:self.selectorCollectedWithFlag withObject:flag];
#pragma clang diagnostic pop
}

//------------------------------------------------------------------------------
-(void) catBoxCollectedWithFlag:(NSNumber*)flag
{
    self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"item_catbox_cat_00_00.png"];

    self.live = FALSE;
}

//------------------------------------------------------------------------------
-(void) dogHouseCollectedWithFlag:(NSNumber*)flag
{
    self.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"item_doghouse_dog_00_00.png"];

    self.live = FALSE;
}

//------------------------------------------------------------------------------
-(void) itemCollectedWithFlag:(NSNumber*)flag
{
    self.visible = FALSE;

    self.live = FALSE;
}

//------------------------------------------------------------------------------
-(void) pad:(float)pad
{
    CGPoint p = self.position;

    p.y += pad;

    self.position = p;
}

//------------------------------------------------------------------------------
@end


