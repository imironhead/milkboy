//
//  MLayerGameSinglePlayer.m
//  Milkboy
//
//  Created by iRonhead on 7/9/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerGameSinglePlayer.h"
#import "MScene.h"


//------------------------------------------------------------------------------
@interface MLayerGameSinglePlayer ()
@property (nonatomic, strong) CCMenu* layerMenuGame;
@property (nonatomic, strong) CCLayer* layerMenuPause;
@property (nonatomic, strong) CCLayer* layerMenuScore;
@end

//------------------------------------------------------------------------------
@implementation MLayerGameSinglePlayer
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.tag = MTagLayerGameSinglePlayer;

        //--button pause
        CCMenuItemSprite* button =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_record.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_record.png"]
                                           target:self
                                         selector:@selector(showMenuPause:)];

        button.scale = 2.0f;
        button.anchorPoint = ccp(0.0f, 0.0f);
        button.position = ccp(-160.0f, -240.0f);
        button.tag = MTagGamePause;

        //--menu
        self.layerMenuGame = [CCMenu menuWithItems:button, nil];

        [self addChild:self.layerMenuGame z:0];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) showMenuPause:(id)sender
{
    NSInteger tag = [(CCNode*)sender tag];

    if (tag == MTagGamePause)
    {
        //
        CCNode* fake = [CCNode new];

        fake.tag = tag;

        MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

        [target onEvent:fake];

        //
        NSAssert(!self.layerMenuPause, @"[MLayerGameSinglePlayer showMenuPause:]");

        //
        self.layerMenuGame.enabled = FALSE;

        //
        CCLayerColor* layerDarken = [CCLayerColor layerWithColor:ccc4(0x00, 0x00, 0x00, 0x00)];

        layerDarken.tag = 0xcdcd0000;

        [layerDarken runAction:[CCFadeTo actionWithDuration:0.5f opacity:0x80]];

        //
        CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"menu_billboard.png"];

        sprite.scale = 2.0f;
        sprite.anchorPoint = ccp(0.5f, 1.0f);
        sprite.position = ccp(160.0f, 480.0f);

        CCSpriteBatchNode* batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Texture/menu.pvr.ccz"];

        [batchNode addChild:sprite];

        //--
        CCLayer* layerUI = [CCLayer new];

        layerUI.tag = 0xcdcd0001;
        layerUI.position = ccp(0.0f, 480.0f);

        [layerUI addChild:batchNode];

        [layerUI runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 0.0f)]];

        //
        CCMenuItemImage* buttonResume =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:self
                                         selector:@selector(showMenuPause:)];

        buttonResume.scale = 2.0f;
        buttonResume.position = ccp(-80.0f, 160.0f);
        buttonResume.tag = MTagGameResume;

        CCMenuItemImage* buttonRestart =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:self
                                         selector:@selector(showMenuPause:)];

        buttonRestart.scale = 2.0f;
        buttonRestart.position = ccp(0.0f, 160.0f);
        buttonRestart.tag = MTagGamePauseRestart;

        CCMenuItemImage* buttonQuit =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:self
                                         selector:@selector(showMenuPause:)];

        buttonQuit.scale = 2.0f;
        buttonQuit.position = ccp(80.0f, 160.0f);
        buttonQuit.tag = MTagGamePauseQuit;

        CCMenu* menu = [CCMenu new];

        [menu addChild:buttonResume];
        [menu addChild:buttonRestart];
        [menu addChild:buttonQuit];

        [layerUI addChild:menu];

        //
        self.layerMenuPause = [CCLayer new];

        [self.layerMenuPause addChild:layerDarken z:0];

        [self.layerMenuPause addChild:layerUI z:1];

        [self addChild:self.layerMenuPause z:1];
    }
    else if (tag == MTagGameResume)
    {
        CCLayerColor* layerDarken = (CCLayerColor*)[self.layerMenuPause getChildByTag:0xcdcd0000];

        [layerDarken runAction:[CCFadeTo actionWithDuration:0.5f opacity:0x00]];

        CCLayer* layerUI = (CCLayer*)[self.layerMenuPause getChildByTag:0xcdcd0001];

        [layerUI runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 480.0f)]];

        CCDelayTime* actionDelay = [CCDelayTime actionWithDuration:0.6f];

        CCCallBlock* actionBlock = [CCCallBlock actionWithBlock:
        ^{
            self.layerMenuGame.enabled = TRUE;

            [self removeChild:self.layerMenuPause cleanup:TRUE];

            self.layerMenuPause = nil;

            //
            CCNode* fake = [CCNode new];

            fake.tag = tag;

            MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

            [target onEvent:fake];
        }];

        [self runAction:[CCSequence actionOne:actionDelay two:actionBlock]];
    }
    else
    {
        //--MTagGamePauseQuit
        //--MTagGamePauseRestart

        //--report
        CCNode* fake = [CCNode new];

        fake.tag = tag;

        MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

        [target onEvent:fake];

        //--hide menu
        CCLayerColor* layerDarken = (CCLayerColor*)[self.layerMenuPause getChildByTag:0xcdcd0000];

        [layerDarken runAction:[CCFadeTo actionWithDuration:0.5f opacity:0x00]];

        CCLayer* layerUI = (CCLayer*)[self.layerMenuPause getChildByTag:0xcdcd0001];

        [layerUI runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 480.0f)]];

        CCDelayTime* actionDelay = [CCDelayTime actionWithDuration:0.6f];

        CCCallBlock* actionBlock = [CCCallBlock actionWithBlock:
        ^{
            self.layerMenuGame.enabled = (tag == MTagGamePauseRestart);

            [self removeChild:self.layerMenuPause cleanup:TRUE];

            self.layerMenuPause = nil;
        }];

        [self runAction:[CCSequence actionOne:actionDelay two:actionBlock]];
    }
}

//------------------------------------------------------------------------------
-(void) showMenuScore:(id)sender
{
    NSInteger tag = [(CCNode*)sender tag];

    if (tag == MTagGameScore)
    {
        NSAssert(!self.layerMenuScore, @"[MLayerGameSinglePlayer showMenuScore:]");

        //
        self.layerMenuGame.enabled = FALSE;

        //
        CCLayerColor* layerDarken = [CCLayerColor layerWithColor:ccc4(0x00, 0x00, 0x00, 0x00)];

        layerDarken.tag = 0xcdcd0000;

        [layerDarken runAction:[CCFadeTo actionWithDuration:0.5f opacity:0x80]];

        //
        CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"menu_billboard.png"];

        sprite.scale = 2.0f;
        sprite.anchorPoint = ccp(0.5f, 1.0f);
        sprite.position = ccp(160.0f, 480.0f);

        CCSpriteBatchNode* batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Texture/menu.pvr.ccz"];

        [batchNode addChild:sprite];

        //--
        CCLayer* layerUI = [CCLayer new];

        layerUI.tag = 0xcdcd0001;
        layerUI.position = ccp(0.0f, 480.0f);

        [layerUI addChild:batchNode];

        [layerUI runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 0.0f)]];

        //
        CCMenuItemImage* buttonRestart =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:self
                                         selector:@selector(showMenuScore:)];

        buttonRestart.scale = 2.0f;
        buttonRestart.position = ccp(0.0f, 160.0f);
        buttonRestart.tag = MTagGameScoreRestart;

        CCMenuItemImage* buttonQuit =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:self
                                         selector:@selector(showMenuScore:)];

        buttonQuit.scale = 2.0f;
        buttonQuit.position = ccp(80.0f, 160.0f);
        buttonQuit.tag = MTagGameScoreQuit;

        CCMenu* menu = [CCMenu new];

        [menu addChild:buttonRestart];
        [menu addChild:buttonQuit];

        [layerUI addChild:menu];

        //
        self.layerMenuScore = [CCLayer new];

        [self.layerMenuScore addChild:layerDarken z:0];

        [self.layerMenuScore addChild:layerUI z:1];

        [self addChild:self.layerMenuScore z:1];
    }
    else if (tag == MTagGameScoreRestart)
    {
        CCNode* fake = [CCNode new];

        fake.tag = MTagGameScoreRestart;

        MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

        [target onEvent:fake];

        //
        CCLayerColor* layerDarken = (CCLayerColor*)[self.layerMenuScore getChildByTag:0xcdcd0000];

        [layerDarken runAction:[CCFadeTo actionWithDuration:0.5f opacity:0x00]];

        CCLayer* layerUI = (CCLayer*)[self.layerMenuScore getChildByTag:0xcdcd0001];

        [layerUI runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 480.0f)]];

        CCDelayTime* actionDelay = [CCDelayTime actionWithDuration:0.6f];

        CCCallBlock* actionBlock = [CCCallBlock actionWithBlock:
        ^{
            self.layerMenuGame.enabled = TRUE;

            [self removeChild:self.layerMenuScore cleanup:TRUE];

            self.layerMenuScore = nil;
        }];

        [self runAction:[CCSequence actionOne:actionDelay two:actionBlock]];
    }
    else if (tag == MTagGameScoreQuit)
    {
        CCNode* fake = [CCNode new];

        fake.tag = tag;

        MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

        [target onEvent:fake];
    }
}

//------------------------------------------------------------------------------
@end
