//
//  MSceneLocalGame.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MBoy.h"
#import "MLayerTower.h"
#import "MSceneLocalGame.h"
#import "MSceneMenuSinglePlayer.h"


//------------------------------------------------------------------------------
@interface MSceneLocalGame()
@property (nonatomic, strong) MLayerTower* layerTower;
@property (nonatomic, strong) CCLabelAtlas* labelDistance;
@property (nonatomic, strong) CCLabelAtlas* labelMilkCount;
@property (nonatomic, strong) CCMenu* menu;
@property (nonatomic, strong) CCLayer* layerMenuPause;
@end

//------------------------------------------------------------------------------
@implementation MSceneLocalGame
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        [self scheduleUpdateWithPriority:0];

        //
        self.layerTower = [MLayerTower layerWithMatch:nil];

        [self addChild:self.layerTower z:0];

        //
        CCLayer* layerUI = [CCLayer new];

        [self addChild:layerUI z:1];

        self.labelDistance =
            [CCLabelAtlas labelWithString:@"0 m"
                              charMapFile:@"fps_images.png"
                                itemWidth:12
                               itemHeight:32
                             startCharMap:'.'];

        self.labelDistance.position = ccp(80.0f, 450.0f);
        self.labelDistance.color = ccc3(0xff, 0xff, 0x80);

        [layerUI addChild:self.labelDistance z:0];

        self.labelMilkCount =
            [CCLabelAtlas labelWithString:@"0 Milk"
                              charMapFile:@"fps_images.png"
                                itemWidth:12
                               itemHeight:32
                             startCharMap:'.'];

        self.labelMilkCount.position = ccp(240.0f, 450.0f);
        self.labelMilkCount.color = ccc3(0x80, 0x80, 0xff);

        [layerUI addChild:self.labelMilkCount z:0];

        //--menu for pause
        self.menu = [CCMenu new];

        CCLabelTTF* lablPause = [CCLabelTTF labelWithString:@"p"
                                                 dimensions:CGSizeMake(20.0f, 20.0f)
                                                 hAlignment:kCCTextAlignmentCenter
                                                   fontName:@"Marker Felt"
                                                   fontSize:20.0f];

        CCMenuItemLabel* btonPause = [CCMenuItemLabel itemWithLabel:lablPause target:self selector:@selector(doPause:)];

        btonPause.anchorPoint = ccp(0.0f, 0.0f);
        btonPause.position = ccp(-160.0f, -240.0f);

        [self.menu addChild:btonPause];

        [self addChild:self.menu];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) update:(ccTime)elapsed
{
    self.labelDistance.string = [NSString stringWithFormat:@"%d", self.layerTower.boyLocal.score];

    self.labelMilkCount.string = [NSString stringWithFormat:@"%d", self.layerTower.boyLocal.milkCount];
}

//------------------------------------------------------------------------------
-(void) doPause:(id)sender
{
    [self.layerTower unscheduleUpdate];

    self.menu.enabled = FALSE;

    //
    self.layerMenuPause = [CCLayer new];

    //--content
    CCLabelTTF* lablScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d", self.layerTower.boyLocal.score]
                                             dimensions:CGSizeMake(160.0f, 30.0f)
                                             hAlignment:kCCTextAlignmentCenter
                                               fontName:@"Marker Felt"
                                               fontSize:20.0f];

    lablScore.position = ccp(160.0f, 360.0f);

    [self.layerMenuPause addChild:lablScore];

    //--menu & buttons
    CCMenu* menuPause = [CCMenu new];

    CCLabelTTF* lablResume = [CCLabelTTF labelWithString:@"resume"
                                             dimensions:CGSizeMake(160.0f, 20.0f)
                                             hAlignment:kCCTextAlignmentCenter
                                               fontName:@"Marker Felt"
                                               fontSize:20.0f];

    CCMenuItemLabel* btonResume = [CCMenuItemLabel itemWithLabel:lablResume target:self selector:@selector(doResume:)];

    btonResume.position = ccp(0.0f, -90.0f);

    [menuPause addChild:btonResume];

    CCLabelTTF* lablRestart = [CCLabelTTF labelWithString:@"restart"
                                               dimensions:CGSizeMake(160.0f, 20.0f)
                                               hAlignment:kCCTextAlignmentCenter
                                                 fontName:@"Marker Felt"
                                                 fontSize:20.0f];

    CCMenuItemLabel* btonRestart = [CCMenuItemLabel itemWithLabel:lablRestart target:self selector:@selector(doRestart:)];

    btonRestart.position = ccp(0.0f, -120.0f);

    [menuPause addChild:btonRestart];

    CCLabelTTF* lablQuit = [CCLabelTTF labelWithString:@"quit"
                                             dimensions:CGSizeMake(160.0f, 20.0f)
                                             hAlignment:kCCTextAlignmentCenter
                                               fontName:@"Marker Felt"
                                               fontSize:20.0f];

    CCMenuItemLabel* btonQuit = [CCMenuItemLabel itemWithLabel:lablQuit target:self selector:@selector(doQuit:)];

    btonQuit.position = ccp(0.0f, -150.0f);

    [menuPause addChild:btonQuit];

    [self.layerMenuPause addChild:menuPause];

    [self addChild:self.layerMenuPause];

    //--action
    self.layerMenuPause.position = ccp(0.0f, 480.0f);

    menuPause.enabled = FALSE;

    CCMoveTo* actionMove = [CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 0.0f)];

    CCCallBlock* actionShow = [CCCallBlock actionWithBlock:^{
        menuPause.enabled = TRUE;
    }];

    CCSequence* actionSequence = [CCSequence actions:actionMove, actionShow, nil];

    [self.layerMenuPause runAction:actionSequence];

}

//------------------------------------------------------------------------------
-(void) doResume:(id)sender
{
    CCMoveTo* actionMove = [CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 480.0f)];

    CCCallBlock* actionHide = [CCCallBlock actionWithBlock:^{
        [self removeChild:self.layerMenuPause cleanup:FALSE];

        self.layerMenuPause = nil;

        self.menu.enabled = TRUE;

        [self.layerTower scheduleUpdate];
    }];

    CCSequence* actionSequence = [CCSequence actions:actionMove, actionHide, nil];

    [self.layerMenuPause runAction:actionSequence];
}

//------------------------------------------------------------------------------
-(void) doRestart:(id)sender
{
    CCScene* next = [MSceneLocalGame new];

    CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

    [[CCDirector sharedDirector] replaceScene:transition];
}

//------------------------------------------------------------------------------
-(void) doQuit:(id)sender
{
    CCScene* next = [MSceneMenuSinglePlayer new];

    CCTransitionCrossFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:next];

    [[CCDirector sharedDirector] replaceScene:transition];
}

//------------------------------------------------------------------------------
@end
