//
//  MLayerMenuRecord.m
//  Milkboy
//
//  Created by iRonhead on 7/31/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerMenuRecord.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuRecord
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.tag = MTagLayerMenuRecord;

        //--target
        id target = [[CCDirector sharedDirector] runningScene];

        //
        CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"menu_billboard.png"];

        sprite.scale = 2.0f;
        sprite.anchorPoint = ccp(0.5f, 1.0f);
        sprite.position = ccp(160.0f, 480.0f);

        CCSpriteBatchNode* batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Texture/menu.pvr.ccz"];

        [batchNode addChild:sprite];

        //
        CCMenuItemSprite* btonHome =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_single_player.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        btonHome.tag = MTagGotoLayerMenuSinglePlayer;

        btonHome.position = ccp(0.0f, -200.0f);

        //--
        CCMenu* menu = [CCMenu new];


        [menu addChild:btonHome];

        [self addChild:batchNode];
        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
