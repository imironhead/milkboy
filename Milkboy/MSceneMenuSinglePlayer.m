//
//  MSceneMenuSinglePlayer.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MSceneLocalGame.h"
#import "MSceneMenuMain.h"
#import "MSceneMenuRecord.h"
#import "MSceneMenuSinglePlayer.h"
#import "MSceneMenuTutorials.h"


//------------------------------------------------------------------------------
@implementation MSceneMenuSinglePlayer
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--background layer

        //--menu layer
        CCMenu* menu = [CCMenu new];

        //--play
        CCLabelTTF* lablPlay = [CCLabelTTF labelWithString:@"PLAY"
                                                dimensions:CGSizeMake(160.0f, 50.0f)
                                                hAlignment:kCCTextAlignmentCenter
                                                  fontName:@"Marker Felt"
                                                  fontSize:40.0f];

        CCMenuItemLabel* btonPlay = [CCMenuItemLabel itemWithLabel:lablPlay
                                                             block:^(id sender) {

            CCScene* next = [MSceneLocalGame new];

            CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

            [[CCDirector sharedDirector] replaceScene:transition];
        }];

        btonPlay.position = ccp(0.0f, 100.0f);

        [menu addChild:btonPlay];

        //--tutorial
        CCLabelTTF* lablTutorial = [CCLabelTTF labelWithString:@"Tutorial"
                                                    dimensions:CGSizeMake(160.0f, 50.0f)
                                                    hAlignment:kCCTextAlignmentCenter
                                                      fontName:@"Marker Felt"
                                                      fontSize:40.0f];

        CCMenuItemLabel* btonTutorial = [CCMenuItemLabel itemWithLabel:lablTutorial
                                                                 block:^(id sender) {
            CCScene* next = [MSceneMenuTutorials new];

            CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

            [[CCDirector sharedDirector] replaceScene:transition];
        }];

        btonTutorial.position = ccp(0.0f, 50.0f);

        [menu addChild:btonTutorial];

        //--record
        CCLabelTTF* lablRecord = [CCLabelTTF labelWithString:@"Record"
                                                  dimensions:CGSizeMake(160.0f, 50.0f)
                                                    hAlignment:kCCTextAlignmentCenter
                                                      fontName:@"Marker Felt"
                                                      fontSize:40.0f];

        CCMenuItemLabel* btonRecord = [CCMenuItemLabel itemWithLabel:lablRecord
                                                                 block:^(id sender) {
            CCScene* next = [MSceneMenuRecord new];

            CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

            [[CCDirector sharedDirector] replaceScene:transition];
        }];

        btonRecord.position = ccp(0.0f, 0.0f);

        [menu addChild:btonRecord];

        //--leader board
        CCLabelTTF* lablLeaderboard = [CCLabelTTF labelWithString:@"Leaderboard"
                                                       dimensions:CGSizeMake(200.0f, 50.0f)
                                                       hAlignment:kCCTextAlignmentCenter
                                                         fontName:@"Marker Felt"
                                                         fontSize:40.0f];

        CCMenuItemLabel* btonLeaderboard = [CCMenuItemLabel itemWithLabel:lablLeaderboard
                                                                    block:^(id sender) {

        }];

        btonLeaderboard.position = ccp(0.0f, -50.0f);

        [menu addChild:btonLeaderboard];

        //--back to main menu
        CCLabelTTF* lablBack = [CCLabelTTF labelWithString:@"Main Menu"
                                                dimensions:CGSizeMake(200.0f, 50.0f)
                                                hAlignment:kCCTextAlignmentCenter
                                                  fontName:@"Marker Felt"
                                                  fontSize:40.0f];

        CCMenuItemLabel* btonBack = [CCMenuItemLabel itemWithLabel:lablBack
                                                             block:^(id sender) {
            CCScene* next = [MSceneMenuMain new];

            CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

            [[CCDirector sharedDirector] replaceScene:transition];
        }];

        btonBack.position = ccp(0.0f, -100.0f);

        [menu addChild:btonBack];

        //--
        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
