//
//  MTowerStep.h
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"
#import "MType.h"


//------------------------------------------------------------------------------
@class MBoy;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerStepBase : NSObject
@property (nonatomic, strong, readonly) CCSprite* sprite;
@property (nonatomic, assign, readonly) MTowerObjectType type;
@property (nonatomic, assign, readonly) uint32_t usid;
@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, assign, readonly) CGRect boundCollision;
@property (nonatomic, assign, readonly) MCollisionRange rangeVisiblity;
@property (nonatomic, assign, readonly) MCollisionRange rangeCollision;

+(id) stepWithType:(MTowerObjectType)type
          position:(CGPoint)position
              usid:(uint32_t)usid
              seed:(uint32_t)seed;

-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh;

-(void) boyJump:(MBoy*)boy;
-(void) boyLand:(MBoy*)boy;
@end

//------------------------------------------------------------------------------
@interface MTowerStepBasement : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepBrittle : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepDrift : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepMove : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepMovingWalkway : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepPatrol : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepPulse : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepSpring : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepStation : MTowerStepBase
@end

//------------------------------------------------------------------------------
@interface MTowerStepSteady : MTowerStepBase
@end

