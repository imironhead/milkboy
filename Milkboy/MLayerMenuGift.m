//
//  MLayerMenuGift.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MGame.h"
#import "MLayerMenuGift.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuGift
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        CCMenu* menu = [CCMenu new];

        //
        CCMenuItemSprite* btonGiftBox =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_gift_box.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_gift_box.png"]
                                           target:self
                                         selector:@selector(onGift:)];

        btonGiftBox.scale = 2.0f;

        btonGiftBox.position = ccp(0.0f, 120.0f);

        [menu addChild:btonGiftBox];

        //
        CCMenuItemSprite* btonGiftText0 =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_gift_text_0.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_gift_text_0.png"]
                                           target:self
                                         selector:@selector(onGift:)];

        btonGiftText0.scale = 2.0f;

        btonGiftText0.position = ccp(0.0f, 0.0f);

        [menu addChild:btonGiftText0];

        //
        CCMenuItemSprite* btonGiftText1 =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_gift_text_1.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_gift_text_1.png"]
                                           target:self
                                         selector:@selector(onGift:)];

        btonGiftText1.scale = 2.0f;

        btonGiftText1.position = ccp(0.0f, -60.0f);

        [menu addChild:btonGiftText1];

        //
        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) onGift:(id)sender
{
}

//------------------------------------------------------------------------------
@end
