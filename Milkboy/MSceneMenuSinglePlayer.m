//
//  MSceneMenuSinglePlayer.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTower.h"
#import "MSceneLocalGame.h"
#import "MSceneMenuMain.h"
#import "MSceneMenuRecord.h"
#import "MSceneMenuSinglePlayer.h"
#import "MSceneMenuTutorials.h"


//------------------------------------------------------------------------------
@interface MSceneMenuSinglePlayer()
@property (nonatomic, strong) MLayerTower* layerTower;
@end

//------------------------------------------------------------------------------
@implementation MSceneMenuSinglePlayer
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];

        [frameCache removeUnusedSpriteFrames];

        NSArray* namesSpriteFrameFile =
        @[
            @"Texture/menu_play.plist",
            @"Texture/back.plist",
            @"Texture/char.plist",
            @"Texture/step.plist",
            @"Texture/wall.plist",
        ];

        for (NSString* name in namesSpriteFrameFile)
        {
            [frameCache addSpriteFramesWithFile:name];
        }

        NSArray* namesTexture =
        @[
            @"Texture/menu_play.pvr.ccz",
            @"Texture/back.pvr.ccz",
            @"Texture/char.pvr.ccz",
            @"Texture/step.pvr.ccz",
            @"Texture/wall.pvr.ccz",
        ];

        CCTextureCache* textureCache = [CCTextureCache sharedTextureCache];

        for (NSString* name in namesTexture)
        {
            [[textureCache addImage:name] setAliasTexParameters];
        }

        //--background layer
        self.layerTower = [MLayerTower layerForMainMenu];

        [self addChild:self.layerTower];

        //--menu layer
        CCMenu* menu = [CCMenu new];

        menu.position = ccp(160.0f, 240.0f);

        [self addChild:menu];

        //--button table
        NSArray* buttonInfos =
        @[
            @[
                @"menu_play_play.png",
                @"menu_play_play.png",
                @"onPlay:",
                @0.0f,
                @80.0f,
            ],
            @[
                @"menu_play_tutorial.png",
                @"menu_play_tutorial.png",
                @"onToturial:",
                @-120.0f,
                @-40.0f,
            ],
            @[
                @"menu_play_record.png",
                @"menu_play_record.png",
                @"onRecord:",
                @-40.0f,
                @-40.0f,
            ],
            @[
                @"menu_play_leaderbord.png",
                @"menu_play_leaderbord.png",
                @"onLeaderboard:",
                @40.0f,
                @-40.0f,
            ],
            @[
                @"menu_play_main_menu.png",
                @"menu_play_main_menu.png",
                @"onMainMenu:",
                @120.0f,
                @-40.0f,
            ],
        ];

        for (NSArray* info in buttonInfos)
        {
            CCMenuItemSprite* button =
                [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:info[0]]
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:info[1]]
                                               target:self
                                             selector:NSSelectorFromString(info[2])];

            button.scale = 2.0f;
            button.position = ccp([(NSNumber*)info[3] floatValue], [(NSNumber*)info[4] floatValue]);

            [menu addChild:button];
        }
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) onEnterTransitionDidFinish
{
    [self.layerTower scheduleUpdate];
}

//------------------------------------------------------------------------------
-(void) onPlay:(id)sender
{
    CCScene* next = [MSceneLocalGame new];

    CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

    [[CCDirector sharedDirector] replaceScene:transition];
}

//------------------------------------------------------------------------------
-(void) onToturial:(id)sender
{
    CCScene* next = [MSceneMenuTutorials new];

    CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

    [[CCDirector sharedDirector] replaceScene:transition];
}

//------------------------------------------------------------------------------
-(void) onRecord:(id)sender
{
    CCScene* next = [MSceneMenuRecord new];

    CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

    [[CCDirector sharedDirector] replaceScene:transition];
}

//------------------------------------------------------------------------------
-(void) onLeaderboard:(id)sender
{}

//------------------------------------------------------------------------------
-(void) onMainMenu:(id)sender
{
    CCScene* next = [MSceneMenuMain new];

    CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

    [[CCDirector sharedDirector] replaceScene:transition];
}

//------------------------------------------------------------------------------
@end
