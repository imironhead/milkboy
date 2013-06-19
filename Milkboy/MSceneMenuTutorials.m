//
//  MSceneMenuTutorials.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "CCScrollLayer.h"
#import "MSceneMenuSinglePlayer.h"
#import "MSceneMenuTutorials.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MLayerMenuTutorials : CCScrollLayer
+(id) layerOfTutorialOfPowerUp;
+(id) layerOfTutorialOfJump;
@end

//------------------------------------------------------------------------------
@implementation MLayerMenuTutorials
//------------------------------------------------------------------------------
+(id) layerOfTutorialOfPowerUp
{
    CCLayer* layer = [CCLayer new];

    CCLabelTTF* label = [CCLabelTTF labelWithString:@"Press to Power Up"
                                         dimensions:CGSizeMake(320.0f, 80.0f)
                                         hAlignment:kCCTextAlignmentCenter
                                           fontName:@"Marker Felt"
                                           fontSize:40.0f];

    label.position = ccp(160.0f, 240.0f);

    [layer addChild:label];

    return layer;
}

//------------------------------------------------------------------------------
+(id) layerOfTutorialOfJump
{
    CCLayer* layer = [CCLayer new];

    CCLabelTTF* label = [CCLabelTTF labelWithString:@"Release to Jump"
                                         dimensions:CGSizeMake(320.0f, 80.0f)
                                         hAlignment:kCCTextAlignmentCenter
                                           fontName:@"Marker Felt"
                                           fontSize:40.0f];

    label.position = ccp(160.0f, 240.0f);

    [layer addChild:label];

    return layer;
}

//------------------------------------------------------------------------------
-(id) init
{
    NSArray* layers = @[
        [MLayerMenuTutorials layerOfTutorialOfPowerUp],
        [MLayerMenuTutorials layerOfTutorialOfJump]];

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
@implementation MSceneMenuTutorials
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--content layer
        [self addChild:[MLayerMenuTutorials new]];

        //--menu layer, button to go back
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
