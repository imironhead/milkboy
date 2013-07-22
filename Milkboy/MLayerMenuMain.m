//
//  MLayerMain.m
//  Milkboy
//
//  Created by iRonhead on 7/5/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerMenuMain.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuMain
//------------------------------------------------------------------------------
-(id) init
{
    return [self initWithTarget:[[CCDirector sharedDirector] runningScene]];
}

//------------------------------------------------------------------------------
-(id) initWithTarget:(id)target
{
    self = [super init];

    if (self)
    {
        //
        self.tag = MTagLayerMenuMain;

        //--
        CCMenuItemSprite* btonPlay =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        btonPlay.tag = MTagGotoLayerMenuSinglePlayer;

        btonPlay.scale = 2.0f;

        btonPlay.position = ccp(0.0f, 80.0f);

        //--
        CCMenuItemSprite* btonOption =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        btonOption.tag = MTagGotoLayerMenuOption;

        btonOption.scale = 2.0f;

        btonOption.position = ccp(-80.0f, -80.0f);

        //--
        CCMenuItemSprite* btonGift =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        btonGift.tag = MTagGotoLayerMenuGift;

        btonGift.scale = 2.0f;

        btonGift.position = ccp(80.0f, -80.0f);

        //--
        CCMenu* menu = [CCMenu new];

        [menu addChild:btonPlay];
        [menu addChild:btonOption];
        [menu addChild:btonGift];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
