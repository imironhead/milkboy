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
        //
        id target = [[CCDirector sharedDirector] runningScene];

        self.tag = MTagLayerMenuGift;

        //
        CCMenuItemSprite* btonGiftBox =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_gift_box.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_gift_box.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        //
        CCMenuItemSprite* btonGiftText0 =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_gift_text_0.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_gift_text_0.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        //
        CCMenuItemSprite* btonGiftText1 =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_gift_text_1.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_gift_text_1.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        //--
        CCMenuItemSprite* btonHome =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        //--
        btonGiftBox.tag = MTagGift;
        btonGiftText0.tag = MTagGift;
        btonGiftText1.tag = MTagGift;
        btonHome.tag = MTagGotoLayerMenuMain;

        btonGiftBox.scale = 2.0f;
        btonGiftText0.scale = 2.0f;
        btonGiftText1.scale = 2.0f;

        btonGiftBox.position = ccp(0.0f, 120.0f);
        btonGiftText0.position = ccp(0.0f, 0.0f);
        btonGiftText1.position = ccp(0.0f, -60.0f);
        btonHome.position = ccp(0.0f, -160.0f);

        //--
        CCMenu* menu = [CCMenu new];

        [menu addChild:btonGiftBox];
        [menu addChild:btonGiftText0];
        [menu addChild:btonGiftText1];
        [menu addChild:btonHome];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
