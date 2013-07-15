//
//  MGame.h
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "MConstant.h"


//------------------------------------------------------------------------------
@interface MGame : NSObject
@property (nonatomic, strong, readonly) NSString* appId;
@property (nonatomic, strong, readonly) NSString* urlGiftApp;
@property (nonatomic, strong, readonly) NSArray* functionItem;
@property (nonatomic, strong, readonly) NSArray* functionStep;
@property (nonatomic, assign, readonly) int32_t weightFunctionItem;
@property (nonatomic, assign, readonly) int32_t weightFunctionStep;

+(id) sharedGame;

-(MTowerObjectType) itemWithParameter:(int32_t)parameter inStage:(uint32_t)stage;
-(MTowerObjectType) stepWithParameter:(int32_t)parameter inStage:(uint32_t)stage;

//+(float) towerWidth;
//+(float) towerLeftWallWidth;
//+(float) towerRightWallWidth;
//+(float) stepWidth;
//+(float) stepHeight;
//+(float) stepColumnWidth;
//+(float) stepColumnVariance;
//+(float) stepRecycleHorizontalAmplitude;
//+(float) stepRecycleHorizontalCycle;
//+(float) stepRecycleVerticalAmplitude;
//+(float) stepRecycleVerticalCycle;
//+(float) stepPulseOnDuration;
//+(float) stepPulseOffDuration;
//+(float) stepExpansiveCycle;
//+(float) stepExpansiveMaximum;
//+(float) floorHeight;
//+(float) speedStepMove;
//
//+(float) stepIntervalOfStage:(int32_t)stage matchGame:(BOOL)matchGame;
//+(int32_t) stageIndexOfHeight:(float)height matchGame:(BOOL)matchGame;;
//+(MCollisionRange) rangeOfStage:(int32_t)stage matchGame:(BOOL)matchGame;
@end