//
//  MLayerMenuOption.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerMenuOption.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuOption
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--credit ironhead
        CCLabelTTF* lablIronhead = [CCLabelTTF labelWithString:@"iRonhead"
                                                    dimensions:CGSizeMake(80.0f, 40.0f)
                                                    hAlignment:kCCTextAlignmentCenter
                                                      fontName:@"Marker Felt"
                                                      fontSize:20.0f];

        lablIronhead.position = ccp(160.0f, 410.0f);

        [self addChild:lablIronhead];

        //--credit cocos2d
        CCLabelTTF* lablCocos2d = [CCLabelTTF labelWithString:@"coco`s 2d"
                                                    dimensions:CGSizeMake(80.0f, 40.0f)
                                                    hAlignment:kCCTextAlignmentCenter
                                                      fontName:@"Marker Felt"
                                                      fontSize:20.0f];

        lablCocos2d.position = ccp(160.0f, 360.0f);

        [self addChild:lablCocos2d];


        //--option
        CCMenu* menu = [CCMenu new];

        CCLabelTTF* lablMusic = [CCLabelTTF labelWithString:@"Music On"
                                                dimensions:CGSizeMake(160.0f, 80.0f)
                                                hAlignment:kCCTextAlignmentCenter
                                                  fontName:@"Marker Felt"
                                                  fontSize:40.0f];

        CCMenuItemLabel* btonMusic = [CCMenuItemLabel itemWithLabel:lablMusic
                                                              block:^(id sender) {
            CCMenuItemLabel* item = (CCMenuItemLabel*)sender;

            item.tag = (1 + item.tag) % 2;

            CCLabelTTF* labl = (CCLabelTTF*)item.label;

            labl.string = item.tag ? @"Music On" : @"Music Off";
        }];

        btonMusic.tag = 1;
        btonMusic.position = ccp(0.0f, -120.0f);

        [menu addChild:btonMusic];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
