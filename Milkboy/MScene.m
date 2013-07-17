//
//  MSceneMenu.m
//  Milkboy
//
//  Created by iRonhead on 7/5/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "CCLayerTransition.h"
#import "MLayerGameSinglePlayer.h"
#import "MLayerMenuGift.h"
#import "MLayerMenuMain.h"
#import "MLayerMenuOption.h"
#import "MLayerMenuSinglePlayer.h"
#import "MLayerMenuTutorials.h"
#import "MLayerTower.h"
#import "MScene.h"


//------------------------------------------------------------------------------
@interface MScene ()
@property (nonatomic, strong) CCLayer* currentLayer;
@end

//------------------------------------------------------------------------------
@implementation MScene
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--tower layer
        [self addChild:[MLayerTower new]];

        //--layer menu main
        self.currentLayer = [[MLayerMenuMain alloc] initWithTarget:self];

        [self addChild:self.currentLayer];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) onEvent:(id)sender
{
    switch ([(CCNode*)sender tag])
    {
    case MTagGotoLayerMenuMain:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuMain new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:0.5f]];
        }
        break;
    case MTagGotoLayerMenuOption:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuOption new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:0.5f]];
        }
        break;
    case MTagGotoLayerMenuGift:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuGift new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:0.5f]];
        }
        break;
    case MTagGotoLayerMenuSinglePlayer:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuSinglePlayer new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:0.5f]];
        }
        break;
    case MTagGotoLayerMenuTutorialBegin:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerTutorialBegin new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:0.5f]];
        }
        break;
    case MTagGotoLayerGameSinglePlayer:
        {
            MLayerTower* layerTower = (MLayerTower*)[self getChildByTag:MTagLayerTower];

            [layerTower setType:MTowerTypeGameSinglePlayer duration:0.5f];

            //--transition
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerGameSinglePlayer new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:0.5f]];
        }
        break;
    }
}

//------------------------------------------------------------------------------
@end
