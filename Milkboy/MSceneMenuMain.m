//
//  MSceneMenuMain.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerMenuGift.h"
#import "MLayerMenuOption.h"
#import "MLayerMenuPlay.h"
#import "MLayerTower.h"
#import "MSceneMenuMain.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MLayerMenuMain ()
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSceneMenuMain ()
@property (nonatomic, strong) MLayerTower* layerTower;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MLayerMenuMain
//------------------------------------------------------------------------------
-(id) init
{
    NSArray* layers = @[
        [MLayerMenuPlay new],
        [MLayerMenuOption new],
        [MLayerMenuGift new]];

    self = [super initWithLayers:layers widthOffset:0.0f];

    if (self)
    {
        self.minimumTouchLengthToSlide = 10.0f;
        self.minimumTouchLengthToChangePage = 30.0f;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSceneMenuMain
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
            @"Texture/menu_main.plist",
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
            @"Texture/menu_main.pvr.ccz",
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

        //
        self.layerTower = [MLayerTower layerForMainMenu];

        [self addChild:self.layerTower];

        [self addChild:[MLayerMenuMain new]];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) onEnterTransitionDidFinish
{
    [self.layerTower scheduleUpdate];
}

//------------------------------------------------------------------------------
@end
