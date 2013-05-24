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
#import "UMath.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerStepBase : NSObject
@property (nonatomic, strong, readonly) CCSprite* sprite;
@property (nonatomic, assign, readonly) MTowerObjectType type;
@property (nonatomic, assign, readonly) uint32_t usid;
@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, assign, readonly) URect boundCollision;
@property (nonatomic, assign, readonly) MCollisionRange rangeVisiblity;
@property (nonatomic, assign, readonly) MCollisionRange rangeCollision;

+(id) stepWithCollisionBound:(URect)bound usid:(uint32_t)usid seed:(uint32_t)seed;
+(id) stepWithType:(MTowerObjectType)type
    collisionBound:(URect)bound
              usid:(uint32_t)usid
              seed:(uint32_t)seed;

-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh;
@end

//------------------------------------------------------------------------------
@interface MTowerStepSteady : MTowerStepBase
@end
