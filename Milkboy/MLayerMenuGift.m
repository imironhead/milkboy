//
//  MLayerMenuGift.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MGame.h"
#import "MLayerMenuGift.h"


//------------------------------------------------------------------------------
@implementation MLayerMenuGift
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        CCMenu* menu = [CCMenu new];

        CCLabelTTF* lablGift = [CCLabelTTF labelWithString:@"gift"
                                                dimensions:CGSizeMake(160.0f, 80.0f)
                                                hAlignment:kCCTextAlignmentCenter
                                                  fontName:@"Marker Felt"
                                                  fontSize:40.0f];

        CCMenuItemLabel* btonGift = [CCMenuItemLabel itemWithLabel:lablGift
                                                             block:^(id sender) {
            NSString* url = [[MGame sharedGame] urlGiftApp];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];

        [menu addChild:btonGift];

        [self addChild:menu];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
