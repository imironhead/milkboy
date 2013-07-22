//
//  MLayerSinglePlayer.m
//  Milkboy
//
//  Created by iRonhead on 7/5/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerMenuSinglePlayer.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuSinglePlayer
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--
        id target = [[CCDirector sharedDirector] runningScene];

        //--
        self.tag = MTagLayerMenuSinglePlayer;

        //--menu layer
        CCMenu* menu = [CCMenu new];

        menu.position = ccp(160.0f, 240.0f);

        [self addChild:menu];

        //--button table
        NSArray* buttonInfos =
        @[
            @[
                @"menu_play.png",
                @"menu_play.png",
                @0.0f,
                @80.0f,
                @(MTagGotoLayerGameSinglePlayer),
            ],
            @[
                @"menu_tutorial.png",
                @"menu_tutorial.png",
                @-120.0f,
                @-40.0f,
                @(MTagGotoLayerMenuTutorialBegin),
            ],
            @[
                @"menu_record.png",
                @"menu_record.png",
                @-40.0f,
                @-40.0f,
                @(MTagGotoLayerMenuRecord),
            ],
            @[
                @"menu_leaderbord.png",
                @"menu_leaderbord.png",
                @40.0f,
                @-40.0f,
                @(MTagShowLeaderboard),
            ],
            @[
                @"menu_main_menu.png",
                @"menu_main_menu.png",
                @120.0f,
                @-40.0f,
                @(MTagGotoLayerMenuMain),
            ],
        ];

        for (NSArray* info in buttonInfos)
        {
            CCMenuItemSprite* button =
                [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:info[0]]
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:info[1]]
                                               target:target
                                             selector:@selector(onEvent:)];

            button.scale = 2.0f;
            button.position = ccp([(NSNumber*)info[2] floatValue], [(NSNumber*)info[3] floatValue]);
            button.tag = [(NSNumber*)info[4] intValue];

            [menu addChild:button];
        }
    }

    return self;
}

//------------------------------------------------------------------------------
@end
