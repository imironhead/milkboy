//
//  MSceneLocalGame.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTower.h"
#import "MSceneLocalGame.h"


//------------------------------------------------------------------------------
@interface MSceneLocalGame()
@property (nonatomic, strong) MLayerTower* layerTower;
@end

//------------------------------------------------------------------------------
@implementation MSceneLocalGame
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.layerTower = [MLayerTower layerWithMatch:nil];

        [self addChild:self.layerTower];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
}

//------------------------------------------------------------------------------
@end
