//
//  MLayerTutorials.m
//  Milkboy
//
//  Created by iRonhead on 7/9/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerMenuTutorials.h"
#import "MScene.h"


//------------------------------------------------------------------------------
@implementation MLayerTutorialBegin
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--main scene
        MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

        //--tmp button
        CCMenuItemSprite* buttonHome =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        buttonHome.scale = 2.0f;
        buttonHome.position = ccp(0.0f, -160.0f);
        buttonHome.tag = MTagGotoLayerMenuSinglePlayer;

        //--menu
        CCMenu* menu = [CCMenu menuWithItems:nil, nil];

        [menu addChild:buttonHome];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
@implementation MLayerTutorialEnd
@end