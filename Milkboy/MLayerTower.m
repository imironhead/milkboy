//
//  MLayerTower.m
//  Milkboy
//
//  Created by iRonhead on 7/8/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerTowerBoy.h"
#import "MLayerTower.h"
#import "MLayerTowerBackground.h"
#import "MLayerTowerObjects.h"
#import "MLayerTowerWall.h"
#import "MScene.h"
#import "MSpriteTowerItem.h"
#import "MSpriteTowerStep.h"


//------------------------------------------------------------------------------
@interface MLayerTower ()
@property (nonatomic, strong) CCLayerColor* layerDarken;
@property (nonatomic, strong) CCLayer* layerCamera;
@property (nonatomic, strong) MLayerTowerBackground* layerBackground;
@property (nonatomic, strong) MLayerTowerBoy* layerBoy;
@property (nonatomic, strong) MLayerTowerObjects* layerObjects;
@property (nonatomic, strong) MLayerTowerWall* layerWall;

@property (nonatomic, assign, readwrite) MTowerType type;
@property (nonatomic, assign) uint32_t seedLarge;
@property (nonatomic, assign) uint32_t seedSmall;
@property (nonatomic, assign) int32_t frameIndex;
@property (nonatomic, assign) MTowerPaddingState paddingState;
@property (nonatomic, assign) BOOL gameOver;
@property (nonatomic, assign) BOOL paused;
@end

//------------------------------------------------------------------------------
@implementation MLayerTower
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--always init to main menu type
        self.tag = MTagLayerTower;
        self.type = MTowerTypeMenuMain;
        self.seedLarge = 1 + arc4random_uniform(65534);
        self.seedSmall = self.seedLarge;
        self.frameIndex = 0;
        self.paddingState = MTowerPaddingStateNone;
        self.gameOver = FALSE;
        self.paused = FALSE;

        //--layer darken
        self.layerDarken = [CCLayerColor layerWithColor:ccc4(0x00, 0x00, 0x00, 0x80)];

        self.layerDarken.tag = MTagLayerDarken;

        [self addChild:self.layerDarken z:MTowerLayerZDarken];

        //--layer camera
        self.layerCamera = [CCLayer new];

        self.layerCamera.tag = MTagLayerCamera;

        self.layerCamera.position = ccp(5.0f, 64.0f);

        [self addChild:self.layerCamera z:MTowerLayerZCamera];

        //--brick
        self.layerBackground = [MLayerTowerBackground new];

        [self.layerCamera addChild:self.layerBackground z:MTowerLayerZBackground];

        //--objects
        self.layerObjects = [MLayerTowerObjects new];

        [self.layerCamera addChild:self.layerObjects z:MTowerLayerZStep];

        //--wall
        self.layerWall = [MLayerTowerWall new];

        [self.layerCamera addChild:self.layerWall z:MTowerLayerZWall];

        //--boy
        self.layerBoy = [MLayerTowerBoy new];

        [self.layerCamera addChild:self.layerBoy z:MTowerLayerZChar];

        //--
        [self scheduleUpdate];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) dealloc
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

//------------------------------------------------------------------------------
-(void) update:(ccTime)elapsed
{
    BOOL inTransition =
        ((self.type == MTowerTypeTransition) ||
         (self.type == MTowerTypeTransitionPauseToQuit) ||
         (self.type == MTowerTypeTransitionPauseToRestart));

    self.frameIndex += 1;

    [self.layerObjects updateToFrame:self.frameIndex];
    [self.layerBoy updateWithObjects:self.layerObjects
                        inTransition:inTransition
                               frame:self.frameIndex];

    if ((self.type == MTowerTypeGameSinglePlayer) ||
        (self.type == MTowerTypeTransitionPauseToQuit) ||
        (self.type == MTowerTypeTransitionPauseToRestart))
    {
        [self updatePadding];
        [self updateCamera];
        [self checkGameOver];

        [self.layerObjects updateDeadLineWithBoy:self.layerBoy];
    }

    [self.layerBackground update];
    [self.layerWall update];
}

//------------------------------------------------------------------------------
-(void) updatePadding
{
    switch (self.paddingState)
    {
    case MTowerPaddingStateNone:
        if (self.layerObjects.deadLine > 0.0f)
        {
            self.paddingState = MTowerPaddingStatePadded;

            self.layerBackground.paddingState = MTowerPaddingStatePadded;

            CGPoint pt = self.layerBoy.feetPosition;

            pt.y += MGAMECONFIG_TOWER_PADDING_RISE;

            self.layerBoy.feetPosition = pt;

            self.layerObjects.padding = MGAMECONFIG_TOWER_PADDING_RISE;
        }
        break;
    case MTowerPaddingStatePadded:
        if (self.layerBoy.feetPosition.y < self.layerObjects.deadLine)
        {
            self.paddingState = MTowerPaddingStateRemoved;

            self.layerBackground.paddingState = MTowerPaddingStateRemoved;

            CGPoint pt = self.layerBoy.feetPosition;

            int32_t bottom = (int32_t)(pt.y - 240.0f);

            int32_t indexB = bottom / MGAMECONFIG_BACK_HEIGHT_FLOOR;

            float diff = indexB * MGAMECONFIG_BACK_HEIGHT_FLOOR;

            pt.y -= diff;

            self.layerBoy.feetPosition = pt;

            self.layerObjects.padding =
                MGAMECONFIG_TOWER_PADDING_RISE - diff;
        }
        break;
    default:
        break;
    }
}

//------------------------------------------------------------------------------
-(void) updateCamera
{
    CGPoint p = self.layerBoy.feetPosition;

    if (p.y > 176.0f /*240.0f - 64.0f*/)
    {
        p.x = 5.0f;
        p.y = 240.0f - p.y;

        self.layerCamera.position = p;
    }
    else
    {
        p.x = 5.0f;
        p.y = 64.0f;

        self.layerCamera.position = p;
    }
}

//------------------------------------------------------------------------------
-(void) checkGameOver
{
    if ((self.gameOver == FALSE) &&
        (self.layerBoy.step != nil) &&
        (self.layerBoy.step.type == MTowerObjectTypeStepBasement))
    {
        NSInteger tag;

        if (self.type == MTowerTypeGameSinglePlayer)
        {
            self.gameOver = (self.paddingState != MTowerPaddingStateNone);

            tag = MTagGameScore;
        }
        else if (self.type == MTowerTypeTransitionPauseToQuit)
        {
            self.gameOver = TRUE;

            tag = MTagGameQuitFromPause;
        }
        else if (self.type == MTowerTypeTransitionPauseToRestart)
        {
            self.gameOver = TRUE;

            tag = MTagGameRestartFromPause;
        }

        if (self.gameOver)
        {
            MScene* target = (MScene*)[[CCDirector sharedDirector] runningScene];

            CCNode* nodeFake = [CCNode new];

            nodeFake.tag = tag;

            [target onEvent:nodeFake];
        }
    }
}

//------------------------------------------------------------------------------
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    self.layerBoy.pressed = TRUE;

    return TRUE;
}

//------------------------------------------------------------------------------
-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
    self.layerBoy.pressed = FALSE;
}

//------------------------------------------------------------------------------
-(void) ccTouchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
    self.layerBoy.pressed = FALSE;
}

//------------------------------------------------------------------------------
-(void) resume
{
    if (self.paused)
    {
        self.paused = FALSE;

        [self scheduleUpdate];
    }
}

//------------------------------------------------------------------------------
-(void) pause
{
    if (!self.paused)
    {
        self.paused = TRUE;

        [self unscheduleUpdate];
    }
}

//------------------------------------------------------------------------------
-(void) transformToType:(MTowerType)type;
{
    if ((type == MTowerTypeTransitionPauseToQuit) ||
        (type == MTowerTypeTransitionPauseToRestart))
    {
        //--user wanna quit or restart from pause menu
        //--mark the type, let the boy drop to 1st floor

        self.type = type;

        //--remove touch if quit to menu
        //--remove touch if rastart since MTowerTypeGameSinglePlayer will register again
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];

        return;
    }

    //--those type have touches, remove touches when leaving them
    if ((self.type == MTowerTypeGameSinglePlayer) ||
        (self.type == MTowerTypeTutorialMilks) ||
        (self.type == MTowerTypeTutorialPower) ||
        (self.type == MTowerTypeTutorialSteps))
    {
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }

    //--mark the type as transition, boy can only collide the basement during transition
    self.type = MTowerTypeTransition;

    self.paddingState = MTowerPaddingStateNone;

    self.gameOver = FALSE;

    //--those tower types do not need darken
    if ((type == MTowerTypeGameSinglePlayer) ||
        (type == MTowerTypeTutorialMilks) ||
        (type == MTowerTypeTutorialPower) ||
        (type == MTowerTypeTutorialSteps))
    {
        if (self.layerDarken.opacity > 0x00)
        {
            [self.layerDarken runAction:[CCFadeTo actionWithDuration:1.0f opacity:0x00]];
        }
    }
    else
    {
        if (self.layerDarken.opacity < 0x80)
        {
            [self.layerDarken runAction:[CCFadeTo actionWithDuration:1.0f opacity:0x80]];
        }
    }

    //--re-arrange all objects for type
    [self.layerObjects transformToType:type];

    //
    CCDelayTime* actionDelay = [CCDelayTime actionWithDuration:1.0f];

    CCCallBlock* actionBlock = [CCCallBlock actionWithBlock:
    ^{
        self.type = type;

        //--register touch events for these types
        if ((type == MTowerTypeGameSinglePlayer) ||
            (type == MTowerTypeTutorialMilks) ||
            (type == MTowerTypeTutorialPower) ||
            (type == MTowerTypeTutorialSteps))
        {
            [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                                      priority:1
                                                               swallowsTouches:TRUE];
        }
    }];

    [self runAction:[CCSequence actions:actionDelay, actionBlock, nil]];

    //--
    if (type == MTowerTypeGameSinglePlayer)
    {
        [self.layerBoy reset];
    }
}

//------------------------------------------------------------------------------
@end
