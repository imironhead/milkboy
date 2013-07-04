//
//  MLayerMenuOption.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerMenuOption.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuOption
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        CCSpriteBatchNode* batchCredit = [CCSpriteBatchNode batchNodeWithFile:@"Texture/menu_main.pvr.ccz"];

        //--credit ironhead
        CCSprite* lablIronhead = [CCSprite spriteWithSpriteFrameName:@"menu_main_credit_ironhead.png"];

        lablIronhead.position = ccp(160.0f, 410.0f);

        lablIronhead.scale = 2.0f;

        [batchCredit addChild:lablIronhead];

        //--credit cocos2d
        CCSprite* lablCocos2d = [CCSprite spriteWithSpriteFrameName:@"menu_main_credit_cocos2d.png"];

        lablCocos2d.position = ccp(160.0f, 360.0f);

        [batchCredit addChild:lablCocos2d];

        //--
        [self addChild:batchCredit];

        //--option
        CCMenu* menu = [CCMenu new];

        CCMenuItemSprite* btonMusic =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_option.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_option.png"]
                                          target:self
                                        selector:@selector(onToggleMusic:)];

        btonMusic.scale = 2.0f;

        btonMusic.position = ccp(0.0f, -120.0f);

        [menu addChild:btonMusic];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) onToggleMusic:(id)sender
{
}

//------------------------------------------------------------------------------
@end
