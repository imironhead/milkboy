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
    MTowerObjectTypeStepBrittle = MTowerObjectTypeStepBase,
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
typedef enum _MTowerSpriteDepth
{
    MTowerSpriteDepthBack,
    MTowerSpriteDepthStep,
    MTowerSpriteDepthWall,
    MTowerSpriteDepthChar,
    MTowerSpriteDepthWater,
    MTowerSpriteDepthEffect,
    MTowerSpriteDepthMenu,
} MTowerSpriteDepth;

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
    MTowerTypeSinglePlayer,
    MTowerTypeBackgroundOfMainMenu,
} MTowerType;

//------------------------------------------------------------------------------

