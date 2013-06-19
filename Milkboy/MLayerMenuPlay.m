//
//  MLayerMenuPlay.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerMenuPlay.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuPlay
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        CCMenu* menu = [CCMenu new];

        CCLabelTTF* lablPlay = [CCLabelTTF labelWithString:@"PLAY"
                                                dimensions:CGSizeMake(160.0f, 80.0f)
                                                hAlignment:kCCTextAlignmentCenter
                                                  fontName:@"Marker Felt"
                                                  fontSize:40.0f];

        CCMenuItemLabel* btonPlay = [CCMenuItemLabel itemWithLabel:lablPlay
                                                             block:^(id sender) {

            CCScene* next = [NSClassFromString(@"MSceneLocalGame") new];

            CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

            [[CCDirector sharedDirector] replaceScene:transition];
        }];

        [menu addChild:btonPlay];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
