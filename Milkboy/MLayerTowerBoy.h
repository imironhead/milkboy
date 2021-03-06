//
//  MLayerTowerBoy.h
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"


//------------------------------------------------------------------------------
@class MLayerTowerObjects;
@class MSpriteTowerItem;
@class MSpriteTowerStep;

//------------------------------------------------------------------------------
@interface MLayerTowerBoy : CCLayer
@property (nonatomic, assign, readonly) CGRect boundCollision;
@property (nonatomic, assign, readonly) uint32_t powerInteger;
@property (nonatomic, assign, readonly) uint32_t powerIntegerMax;
@property (nonatomic, assign, readonly) uint32_t powerDecimal;
@property (nonatomic, assign, readonly) uint32_t powerDecimalMax;
@property (nonatomic, assign, readonly) uint32_t powerDecimalDelta;
@property (nonatomic, assign, readonly) uint32_t coin;
@property (nonatomic, assign, readonly) uint32_t combo;
@property (nonatomic, assign, readonly) uint32_t height;
@property (nonatomic, assign, readonly) uint32_t score;
@property (nonatomic, assign, readonly) MBoyPet pet;
@property (nonatomic, assign, readonly) MBoySuit suit;
@property (nonatomic, assign) CGPoint feetPosition;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint acceleration;
@property (nonatomic, assign) uint32_t milkCount;
@property (nonatomic, assign) BOOL pressed;
@property (nonatomic, weak) MSpriteTowerStep* step;

-(BOOL) collectItem:(MSpriteTowerItem*)item;
-(void) reset;
-(void) updateWithObjects:(MLayerTowerObjects*)objects
             inTransition:(BOOL)inTransition
                    frame:(int32_t)frame;
@end
