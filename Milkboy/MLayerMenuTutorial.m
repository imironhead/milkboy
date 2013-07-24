//
//  MLayerTutorial.m
//  Milkboy
//
//  Created by iRonhead on 7/9/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerMenuTutorial.h"
#import "MScene.h"


//------------------------------------------------------------------------------
typedef enum _MToturial
{
    MToturialInvalid = -1,
    MToturialStory,
    MToturialPower,
    MToturialSteps,
    MToturialMilks,
    MToturialScore,
} MToturial;

//------------------------------------------------------------------------------
@interface MLayerTutorial ()
@property (nonatomic, strong) CCSpriteBatchNode* billboards;
@property (nonatomic, strong) CCMenu* menu;
@property (nonatomic, strong) CCMenuItemSprite* buttonTutorialPrev;
@property (nonatomic, strong) CCMenuItemSprite* buttonTutorialNext;
@property (nonatomic, assign) MToturial currentToturial;
@end

//------------------------------------------------------------------------------
@implementation MLayerTutorial
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.tag = MTagLayerMenuTutorial;

        self.currentToturial = MToturialInvalid;

        //--menu layer
        //--main scene
        MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

        //--tmp button
        CCMenuItemSprite* buttonHome =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:target
                                         selector:@selector(onEvent:)];

        buttonHome.scale = 2.0f;
        buttonHome.position = ccp(0.0f, -160.0f);
        buttonHome.tag = MTagGotoLayerMenuSinglePlayer;

        //
        self.buttonTutorialPrev =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:self
                                         selector:@selector(showTutorial:)];

        self.buttonTutorialPrev.scale = 2.0f;
        self.buttonTutorialPrev.position = ccp(-80.0f, -160.0f);
        self.buttonTutorialPrev.tag = MTagGotoLayerMenuSinglePlayer;

        self.buttonTutorialPrev.visible = FALSE;

        //
        self.buttonTutorialNext =
            [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"menu_main_menu.png"]
                                           target:self
                                         selector:@selector(showTutorial:)];

        self.buttonTutorialNext.scale = 2.0f;
        self.buttonTutorialNext.position = ccp(80.0f, -160.0f);
        self.buttonTutorialNext.tag = MTagGotoLayerMenuSinglePlayer;

        //--menu
        self.menu = [CCMenu menuWithItems:nil, nil];

        [self.menu addChild:buttonHome];
        [self.menu addChild:self.buttonTutorialPrev];
        [self.menu addChild:self.buttonTutorialNext];

        [self addChild:self.menu z:1];

        //--billboard layer
        self.billboards = [CCSpriteBatchNode batchNodeWithFile:@"Texture/menu.pvr.ccz"];

        self.billboards.anchorPoint = ccp(0.0f, 0.0f);
        self.billboards.position = ccp(0.0f, 0.0f);

        [self addChild:self.billboards z:1];

        //--transform tower
        CCNode* fake = [CCNode new];

        fake.tag = MTagTowerTransformToTutorialStory;

        [target onEvent:fake];

        //
        [self transformToTutorial:MToturialStory];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) transformToTutorial:(MToturial)tutorial
{
    NSAssert(self.currentToturial != tutorial, @"[MLayerTutorial transformToTutorial:]");

    //--lock the menu
    self.menu.enabled = FALSE;

    NSMutableArray* actions = [NSMutableArray array];

    if (self.billboards.children.count)
    {
        float tx = (tutorial > self.currentToturial) ? -320.0f : 320.0f;

        [actions addObject:[CCMoveTo actionWithDuration:0.5f position:ccp(tx, 0.0f)]];

        [actions addObject:[CCCallBlock actionWithBlock:
            ^{
                [self.billboards removeAllChildrenWithCleanup:TRUE];
            }]];
    }

    [actions addObject:[CCCallBlock actionWithBlock:
        ^{
            float tx = (tutorial > self.currentToturial) ? 320.0f : -320.0f;

            self.billboards.position = ccp(tx, 0.0f);

            //--new content
            CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"menu_billboard.png"];

            sprite.scale = 2.0f;
            sprite.anchorPoint = ccp(0.5f, 1.0f);
            sprite.position = ccp(160.0f, 480.0f);

            [self.billboards addChild:sprite];
        }]];

    [actions addObject:[CCMoveTo actionWithDuration:0.5f position:ccp(0.0f, 0.0f)]];

    [actions addObject:[CCCallBlock actionWithBlock:
        ^{
            self.currentToturial = tutorial;

            self.menu.enabled = TRUE;

            if (tutorial > MToturialStory)
            {
                self.buttonTutorialPrev.tag = tutorial - 1;

                self.buttonTutorialPrev.visible = TRUE;
            }
            else
            {
                self.buttonTutorialPrev.visible = FALSE;
            }

            if (tutorial < MToturialScore)
            {
                self.buttonTutorialNext.tag = tutorial + 1;

                self.buttonTutorialNext.visible = TRUE;
            }
            else
            {
                self.buttonTutorialNext.visible = FALSE;
            }
        }]];

    [self.billboards runAction:[CCSequence actionWithArray:actions]];
}

//------------------------------------------------------------------------------
-(void) showTutorial:(id)sender
{
    NSInteger tag = [(CCNode*)sender tag];

    [self transformToTutorial:tag];

    NSInteger flag;

    switch (tag)
    {
    case MToturialStory:    flag = MTagTowerTransformToTutorialStory;   break;
    case MToturialPower:    flag = MTagTowerTransformToTutorialPower;   break;
    case MToturialSteps:    flag = MTagTowerTransformToTutorialSteps;   break;
    case MToturialMilks:    flag = MTagTowerTransformToTutorialMilks;   break;
    case MToturialScore:    flag = MTagTowerTransformToTutorialScore;   break;
    }

    CCNode* fake = [CCNode new];

    fake.tag = flag;

    MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

    [target onEvent:fake];
}

//------------------------------------------------------------------------------
@end

