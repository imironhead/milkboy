//
//  MLayerMenuOption.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerMenuOption.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuOption
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.tag = MTagLayerMenuOption;

        //--target
        id target = [[CCDirector sharedDirector] runningScene];

        //--batch node
        CCSpriteBatchNode* batchCredit = [CCSpriteBatchNode batchNodeWithFile:@"Texture/menu.pvr.ccz"];

        //--credit ironhead
        CCSprite* lablIronhead = [CCSprite spriteWithSpriteFrameName:@"menu_credit_ironhead.png"];

        lablIronhead.position = ccp(160.0f, 410.0f);

        lablIronhead.scale = 2.0f;

        [batchCredit addChild:lablIronhead];

        //--credit cocos2d
        CCSprite* lablCocos2d = [CCSprite spriteWithSpriteFrameName:@"menu_credit_cocos2d.png"];

        lablCocos2d.position = ccp(160.0f, 360.0f);

        [batchCredit addChild:lablCocos2d];

        //--toggle music
        CCMenuItemSprite* btonMusic =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_option.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_option.png"]
                                           target:target
                                          selector:@selector(onEvent:)];

        btonMusic.tag = MTagToggleMusic;

        btonMusic.scale = 2.0f;

        btonMusic.position = ccp(0.0f, -120.0f);

        //
        CCMenuItemSprite* btonHome =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        btonHome.tag = MTagGotoLayerMenuMain;

        btonHome.position = ccp(0.0f, -200.0f);

        //--
        CCMenu* menu = [CCMenu new];

        [menu addChild:btonMusic];
        [menu addChild:btonHome];

        [self addChild:batchCredit];
        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
