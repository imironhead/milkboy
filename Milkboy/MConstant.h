//
//  MConstant.h
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
typedef enum _MTowerObjectType
{
    MTowerObjectTypeStepBase = 0,
    MTowerObjectTypeStepBasement = MTowerObjectTypeStepBase,
    MTowerObjectTypeStepBrittle,
    MTowerObjectTypeStepDrift,
    MTowerObjectTypeStepMoveLeft,
    MTowerObjectTypeStepMoveRight,
    MTowerObjectTypeStepMovingWalkwayLeft,
    MTowerObjectTypeStepMovingWalkwayRight,
    MTowerObjectTypeStepPatrolHorizontal,
    MTowerObjectTypeStepPatrolVertical,
    MTowerObjectTypeStepPulse,
    MTowerObjectTypeStepSpring,
    MTowerObjectTypeStepStation,
    MTowerObjectTypeStepSteady,
    MTowerObjectTypeStepMax,

    MTowerObjectTypeItemBase = 0x00001000,
    MTowerObjectTypeItemBomb = MTowerObjectTypeItemBase,
    MTowerObjectTypeItemBox,
    MTowerObjectTypeItemCat,
    MTowerObjectTypeItemMilkAgile,
    MTowerObjectTypeItemMilkDash,
    MTowerObjectTypeItemMilkDoubleJump,
    MTowerObjectTypeItemMilkGlide,
    MTowerObjectTypeItemMilkStrength,
    MTowerObjectTypeItemMilkStrengthExtra,
    MTowerObjectTypeItemMax,

    MTowerObjectTypeInvalid,
} MTowerObjectType;

//------------------------------------------------------------------------------
typedef enum _MTowerObjectGroup
{
    MTowerObjectGroupStep = 0,
    MTowerObjectGroupItem = 1,
} MTowerObjectGroup;

//------------------------------------------------------------------------------
enum
{
    MTowerLayerZCamera = 0,
    MTowerLayerZBackground,
    MTowerLayerZStep,
    MTowerLayerZWall,
    MTowerLayerZChar,
    MTowerLayerZEffect,
    MTowerLayerZDarken,
};

//------------------------------------------------------------------------------
typedef enum _MBoyState
{
    MBoyStateInvalid = 0,
    MBoyStateAgile,
    MBoyStateDoubleJump,
    MBoyStateGlide,
    MBoyStateStrengthExtra,
} MBoyState;

//------------------------------------------------------------------------------
typedef enum _MScore
{
    MScorePerJump           = 5,
    MScorePerMeter          = 10,
    MScorePerCat            = 30,
    MScorePerCatBox         = 200,
    MScorePerMilk           = 5,
    MScorePerFlavoredMilk   = 20,
    MScorePerFrameInFlood   = 10,
} MScore;

//------------------------------------------------------------------------------
typedef enum _MTowerType
{
    MTowerTypeMenuMain,
    MTowerTypeGameSinglePlayer,
    MTowerTypeTransition,
    MTowerTypeTransitionPauseToQuit,
    MTowerTypeTransitionPauseToRestart,
    MTowerTypeTutorialMilks,
    MTowerTypeTutorialPower,
    MTowerTypeTutorialScore,
    MTowerTypeTutorialSteps,
    MTowerTypeTutorialStory,
} MTowerType;

//------------------------------------------------------------------------------
enum
{
    MTagGift = 0x40000000,

    MTagGamePause,
    MTagGamePauseQuit,
    MTagGamePauseRestart,
    MTagGameQuitFromPause,
    MTagGameRestartFromPause,
    MTagGameResume,
    MTagGameScore,
    MTagGameScoreQuit,
    MTagGameScoreRestart,
    MTagGotoLayerGameSinglePlayer,
    MTagGotoLayerMenuGift,
    MTagGotoLayerMenuMain,
    MTagGotoLayerMenuOption,
    MTagGotoLayerMenuRecord,
    MTagGotoLayerMenuSinglePlayer,
    MTagGotoLayerMenuTutorial,
    MTagLayerCamera,
    MTagLayerDarken,
    MTagLayerGameSinglePlayer,
    MTagLayerMenuGift,
    MTagLayerMenuMain,
    MTagLayerMenuOption,
    MTagLayerMenuSinglePlayer,
    MTagLayerMenuTutorial,
    MTagLayerTower,
    MTagShowLeaderboard,
    MTagToggleMusic,
    MTagToggleSound,
    MTagTowerTransformToTutorialMilks,
    MTagTowerTransformToTutorialPower,
    MTagTowerTransformToTutorialScore,
    MTagTowerTransformToTutorialSteps,
    MTagTowerTransformToTutorialStory,
};

//------------------------------------------------------------------------------
typedef enum _MTowerPaddingState
{
    MTowerPaddingStateNone,
    MTowerPaddingStatePadded,
    MTowerPaddingStateRemoved,
} MTowerPaddingState;

//------------------------------------------------------------------------------
