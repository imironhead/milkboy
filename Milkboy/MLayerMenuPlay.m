//
//  MLayerMenuPlay.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerMenuPlay.h"
#import "MSceneMenuSinglePlayer.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuPlay
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //
        CCMenuItemSprite* btonPlay =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_single_player.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_single_player.png"]
                                           target:self
                                         selector:@selector(onPlay:)];

        btonPlay.scale = 2.0f;

        CCMenu* menu = [CCMenu new];

        menu.position = ccp(160.0f, 240.0f);

        [menu addChild:btonPlay];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) onPlay:(id)sender
{
    CCScene* next = [MSceneMenuSinglePlayer new];

    CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

    [[CCDirector sharedDirector] replaceScene:transition];
}

//------------------------------------------------------------------------------
@end
