//
//  MTowerStage.h
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "MType.h"
#import "UMath.h"


//------------------------------------------------------------------------------
@class MTowerItemBase;
@class MTowerStepBase;

//------------------------------------------------------------------------------
@interface MTowerStage : NSObject
@property (nonatomic, strong, readonly) NSArray* steps;
@property (nonatomic, strong, readonly) NSArray* items;
@property (nonatomic, assign, readonly) uint32_t stageIndex;
@property (nonatomic, assign, readonly) uint32_t frameIndex;
@property (nonatomic, assign, readonly) uint32_t seed;
@property (nonatomic, assign, readonly) MCollisionRange rangeCollision;

+(id) stageWithIndex:(uint32_t)index seed:(uint32_t)seed matchGame:(BOOL)matchGame;

-(NSArray*) collideItemWithPosition:(CGPoint)position
                           velocity:(CGPoint)velocity
                              bound:(URect)bound;
-(MTowerStepBase*) collideStepWithPosition:(CGPoint)position
                                  velocity:(CGPoint*)velocity
                                     bound:(URect)bound;
-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh;
@end
