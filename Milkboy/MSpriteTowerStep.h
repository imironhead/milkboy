//
//  MSpriteTowerStep.h
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"


//------------------------------------------------------------------------------
@class MLayerTowerBoy;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerStepBase : CCSprite
@property (nonatomic, assign, readonly) MTowerObjectType type;
@property (nonatomic, assign, readonly) uint32_t usid;
@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, assign, readonly) NSRange range;

+(id) stepWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(uint32_t)seed;

-(void) updateToFrame:(int32_t)frame;
-(void) boyJump:(MLayerTowerBoy*)boy;
-(void) boyLand:(MLayerTowerBoy*)boy;
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepBasement : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepBrittle : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepDrift : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepMove : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepMovingWalkway : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepPatrol : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepPulse : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepSpring : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepStation : MSpriteTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MSpriteTowerStepSteady : MSpriteTowerStepBase
@end

