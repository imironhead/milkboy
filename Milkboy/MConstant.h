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
    MTowerObjectTypeStepSteady,
    MTowerObjectTypeStepMoveLeft,
    MTowerObjectTypeStepMoveRight,
    MTowerObjectTypeStepFlowLeft,
    MTowerObjectTypeStepFlowRight,
    MTowerObjectTypeStepRecycleHorizontal,
    MTowerObjectTypeStepRecycleVertical,
    MTowerObjectTypeStepSpring,
    MTowerObjectTypeStepBrittle,
    MTowerObjectTypeStepPulse,
    MTowerObjectTypeStepExpansive,
    MTowerObjectTypeStepRubber,

    MTowerObjectTypeItemMilkAgile,
    MTowerObjectTypeItemMilkDash,
    MTowerObjectTypeItemMilkDoubleJump,
    MTowerObjectTypeItemMilkGlide,
    MTowerObjectTypeItemMilkStrength,
    MTowerObjectTypeItemMilkStrengthExtra,
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

