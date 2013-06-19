//
//  MSceneMenuRecord.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MSceneMenuRecord.h"
#import "MSceneMenuSinglePlayer.h"


//------------------------------------------------------------------------------
@implementation MSceneMenuRecord
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--record
        CCLabelTTF* lablRecordScore = [CCLabelTTF labelWithString:@"Score: 3333"
                                                       dimensions:CGSizeMake(320.0f, 80.0f)
                                                       hAlignment:kCCTextAlignmentCenter
                                                         fontName:@"Marker Felt"
                                                         fontSize:40.0f];
        lablRecordScore.position = ccp(160.0f, 360.0f);


        [self addChild:lablRecordScore];

        CCLabelTTF* lablRecordHeight = [CCLabelTTF labelWithString:@"Height: 1999"
                                                        dimensions:CGSizeMake(320.0f, 80.0f)
                                                        hAlignment:kCCTextAlignmentCenter
                                                          fontName:@"Marker Felt"
                                                          fontSize:40.0f];

        lablRecordHeight.position = ccp(160.0f, 310.0f);

        [self addChild:lablRecordHeight];

        //--menu, button to go back
        CCMenu* menu = [CCMenu new];

        CCLabelTTF* lablBack = [CCLabelTTF labelWithString:@"BACK"
                                                dimensions:CGSizeMake(160.0f, 80.0f)
                                                hAlignment:kCCTextAlignmentCenter
                                                  fontName:@"Marker Felt"
                                                  fontSize:40.0f];

        CCMenuItemLabel* btonBack = [CCMenuItemLabel itemWithLabel:lablBack
                                                             block:^(id sender) {

            CCScene* next = [MSceneMenuSinglePlayer new];

            CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

            [[CCDirector sharedDirector] replaceScene:transition];
        }];

        btonBack.position = ccp(0.0f, -120.0f);

        [menu addChild:btonBack];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
