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

    MTowerObjectTypeItemBase = 1000,
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
} MTowerType;

//------------------------------------------------------------------------------
enum
{
    MTagGift = 0x40000000,

    MTagGotoLayerGameSinglePlayer,
    MTagGotoLayerMenuGift,
    MTagGotoLayerMenuMain,
    MTagGotoLayerMenuOption,
    MTagGotoLayerMenuRecord,
    MTagGotoLayerMenuSinglePlayer,
    MTagLayerCamera,
    MTagLayerDarken,
    MTagLayerGameSinglePlayer,
    MTagLayerMenuGift,
    MTagLayerMenuMain,
    MTagLayerMenuOption,
    MTagLayerMenuSinglePlayer,
    MTagLayerTower,
    MTagGotoLayerMenuTutorialBegin,
    MTagShowLeaderboard,
    MTagToggleMusic,
    MTagToggleSound,
};

//------------------------------------------------------------------------------
typedef enum _MTowerPaddingState
{
    MTowerPaddingStateNone,
    MTowerPaddingStatePadded,
    MTowerPaddingStateRemoved,
} MTowerPaddingState;

//------------------------------------------------------------------------------
