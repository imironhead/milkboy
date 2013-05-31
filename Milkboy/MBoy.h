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
@property (nonatomic, assign, readonly) uint32_t powerInteger;
@property (nonatomic, assign, readonly) uint32_t powerIntegerMax;
@property (nonatomic, assign, readonly) uint32_t powerDecimal;
@property (nonatomic, assign, readonly) uint32_t powerDecimalMax;
@property (nonatomic, assign, readonly) uint32_t powerDecimalDelta;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint acceleration;
@property (nonatomic, assign) uint32_t coinCount;
@property (nonatomic, assign) uint32_t milkCount;
@property (nonatomic, weak) MTowerStepBase* step;

-(void) updatePower:(BOOL)powerUp;
-(BOOL) drinkMilk:(uint32_t)count;
@end
