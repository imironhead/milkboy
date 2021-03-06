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
#import "MLayerMenuRecord.h"
#import "MLayerMenuSinglePlayer.h"
#import "MLayerMenuTutorial.h"
#import "MLayerTower.h"
#import "MNodeDictionary.h"
#import "MScene.h"


//------------------------------------------------------------------------------
@interface MScene ()
@property (nonatomic, strong) CCLayer* currentLayer;
@property (nonatomic, strong) MLayerTower* layerTower;
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
        self.layerTower = [MLayerTower new];

        [self addChild:self.layerTower];

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
    case MTagGamePause:
        {
            [self.layerTower pause];
        }
        break;
    case MTagGamePauseQuit:
        {
            [self.layerTower transformToType:MTowerTypeTransitionPauseToQuit];

            [self.layerTower resume];
        }
        break;
    case MTagGamePauseRestart:
        {
            [self.layerTower transformToType:MTowerTypeTransitionPauseToRestart];

            [self.layerTower resume];
        }
        break;
    case MTagGameQuitFromPause:
        {
            [self.layerTower transformToType:MTowerTypeMenuMain];

            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuSinglePlayer new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:1.0f]];
        }
        break;
    case MTagGameRestartFromPause:
        {
            [self.layerTower transformToType:MTowerTypeGameSinglePlayer];
        }
        break;
    case MTagGameScoreQuit:
        {
            [self.layerTower transformToType:MTowerTypeMenuMain];

            [self.layerTower resume];

            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuSinglePlayer new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:1.0f]];
        }
        break;
    case MTagGameScoreRestart:
        {
            [self.layerTower transformToType:MTowerTypeGameSinglePlayer];
        }
        break;
    case MTagGameUpdateHeader:
        {
            if ([self.currentLayer class] == [MLayerGameSinglePlayer class])
            {
                [(MLayerGameSinglePlayer*)self.currentLayer updateHeader:[(MNodeDictionary*)sender info]];
            }
        }
        break;
    case MTagGameResume:
        {
            [self.layerTower resume];
        }
        break;
    case MTagGameScore:
        {
            NSAssert([self.currentLayer class] == [MLayerGameSinglePlayer class], @"[MScene onEvent:MTagGameScore]");

            [(MLayerGameSinglePlayer*)self.currentLayer showMenuScore:sender];
        }
        break;
    case MTagGotoLayerMenuMain:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuMain new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:1.0f]];
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
                                                      duration:1.0f]];
        }
        break;
    case MTagGotoLayerMenuRecord:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuRecord new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:1.0f]];
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
                                                      duration:1.0f]];
        }
        break;
    case MTagGotoLayerMenuSinglePlayer:
        {
            [self.layerTower transformToType:MTowerTypeMenuMain];

            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerMenuSinglePlayer new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:1.0f]];
        }
        break;
    case MTagGotoLayerMenuTutorial:
        {
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerTutorial new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:1.0f]];
        }
        break;
    case MTagGotoLayerGameSinglePlayer:
        {
            [self.layerTower transformToType:MTowerTypeGameSinglePlayer];

            //--transition
            CCLayer* layerPrev = self.currentLayer;
            CCLayer* layerNext = [MLayerGameSinglePlayer new];

            self.currentLayer = layerNext;

            [self addChild:
                [CCLayerTransitionCrossFade layerWithPrevLayer:layerPrev
                                                     nextLayer:layerNext
                                                      duration:1.0f]];
        }
        break;
    case MTagShowLeaderboard:
        {
        }
        break;
    case MTagTowerTransformToTutorialMilks:
        {
            [self.layerTower transformToType:MTowerTypeTutorialMilks];
        }
        break;
    case MTagTowerTransformToTutorialPower:
        {
            [self.layerTower transformToType:MTowerTypeTutorialPower];
        }
        break;
    case MTagTowerTransformToTutorialScore:
        {
            [self.layerTower transformToType:MTowerTypeTutorialScore];
        }
        break;
    case MTagTowerTransformToTutorialSteps:
        {
            [self.layerTower transformToType:MTowerTypeTutorialSteps];
        }
        break;
    case MTagTowerTransformToTutorialStory:
        {
            [self.layerTower transformToType:MTowerTypeTutorialStory];
        }
        break;
    }
}

//------------------------------------------------------------------------------
@end
