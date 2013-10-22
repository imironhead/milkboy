//
//  MConstant.h
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//--value
#define MGAMECONFIG_BACK_COUNT_TILE_PER_FLOOR       (20)
#define MGAMECONFIG_BACK_HEIGHT_FLOOR               (1280.0f)
#define MGAMECONFIG_BACK_HEIGHT_TILE                (64.0f)
#define MGAMECONFIG_COMBO_POINT_DECREASE_PER_FRAME  (1)
#define MGAMECONFIG_COMBO_POINT_DIVISOR             (30)
#define MGAMECONFIG_COMBO_POINT_INCREASE_PER_COIN   (30)
#define MGAMECONFIG_COMBO_POINT_MAX                 (300)
#define MGAMECONFIG_COMBO_POINT_THRESHOLD           (150)
#define MGAMECONFIG_POWER_DECIMAL_DELTA             (1)
#define MGAMECONFIG_POWER_DECIMAL_MAX               (6)
#define MGAMECONFIG_TOWER_PADDING_RISE              (1280.0f)
//--method
#define MGAMECONFIG_DROP_LOST_POWER                 (1)
#define MGAMECONFIG_MILK_UPGRADE_STRENGTH           (0)

//------------------------------------------------------------------------------
typedef enum _MTowerObjectType
{
    MTowerObjectTypeStepBase = 0,
    MTowerObjectTypeStepBasement = MTowerObjectTypeStepBase,
    MTowerObjectTypeStepAbsorb,
    MTowerObjectTypeStepDisposable,
    MTowerObjectTypeStepDrift,
    MTowerObjectTypeStepMoveLeft,
    MTowerObjectTypeStepMoveRight,
    MTowerObjectTypeStepMovingWalkwayLeft,
    MTowerObjectTypeStepMovingWalkwayRight,
    MTowerObjectTypeStepPatrolHorizontal,
    MTowerObjectTypeStepPatrolVertical,
    MTowerObjectTypeStepPulse,
    MTowerObjectTypeStepSpring,
    MTowerObjectTypeStepSpringChargeAuto,
    MTowerObjectTypeStepSteady,
    MTowerObjectTypeStepMax,

    MTowerObjectTypeItemBase = 0x00001000,
    MTowerObjectTypeItemBombBig = MTowerObjectTypeItemBase,
    MTowerObjectTypeItemBombSmall,
    MTowerObjectTypeItemCat,
    MTowerObjectTypeItemCatBox,
    MTowerObjectTypeItemCoinGold,
    MTowerObjectTypeItemCollectionMilk_00,
    MTowerObjectTypeItemCollectionMilk_01,
    MTowerObjectTypeItemCollectionMilk_02,
    MTowerObjectTypeItemCollectionMilk_03,
    MTowerObjectTypeItemCollectionMilk_04,
    MTowerObjectTypeItemCollectionMilk_05,
    MTowerObjectTypeItemDog,
    MTowerObjectTypeItemDogHouse,
    MTowerObjectTypeItemQuestionMark,
    MTowerObjectTypeItemSuitAstronaut,
    MTowerObjectTypeItemSuitCEO,
    MTowerObjectTypeItemSuitCommoner,
    MTowerObjectTypeItemSuitJetpack,
    MTowerObjectTypeItemSuitNinja,
//    MTowerObjectTypeItemSuitSanta,
    MTowerObjectTypeItemSuitSuperhero,

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
typedef enum _MBoySuit
{
    MBoySuitInvalid = 0,

    MBoySuitAstronaut,
    MBoySuitCEO,            //--double income
    MBoySuitCommoner,
//    MBoySuitFatcat,
    MBoySuitJetpack,
    MBoySuitNinja,
//    MBoySuitSanta,          //--christmas
    MBoySuitSuperhero,
} MBoySuit;

//------------------------------------------------------------------------------
typedef enum _MBoyPet
{
    MBoyPetNone,
    MBoyPetCat,
    MBoyPetDog,
} MBoyPet;

//------------------------------------------------------------------------------
typedef enum _MScore
{
    MScorePerJump           = 5,
    MScorePerMeter          = 10,
    MScorePerCat            = 30,
    MScorePerCatBox         = 200,
    MScorePerSuit           = 20,
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
    MTagGameUpdateHeader,
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
    MTagLayerMenuRecord,
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
