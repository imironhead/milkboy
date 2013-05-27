//
//  MBoy.h
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "UMath.h"


//------------------------------------------------------------------------------
@class MTowerStepBase;

//------------------------------------------------------------------------------
@interface MBoyLocal : NSObject
@property (nonatomic, strong, readonly) CCSpriteBatchNode* sprite;
@property (nonatomic, assign, readonly) float defaultMoveSpeed;
@property (nonatomic, assign, readonly) float defaultJumpSpeed;
@property (nonatomic, assign, readonly) float defaultGravity;
@property (nonatomic, assign, readonly) float defaultPowerMax;
@property (nonatomic, assign, readonly) float defaultPowerAdd;
@property (nonatomic, assign, readonly) URect boundCollision;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint acceleration;
@property (nonatomic, assign) float power;
@property (nonatomic, assign) float powerMax;
@property (nonatomic, assign) float powerAdd;
@property (nonatomic, assign) uint32_t coin;
@property (nonatomic, weak) MTowerStepBase* step;
@end
