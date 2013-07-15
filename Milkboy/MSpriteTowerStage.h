//
//  MSpriteTowerStage.h
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@class MSpriteTowerItemBase;
@class MSpriteTowerStepBase;

//------------------------------------------------------------------------------
@interface MSpriteTowerStage : CCSprite
@property (nonatomic, strong, readonly) NSArray* steps;
@property (nonatomic, strong, readonly) NSArray* items;
@property (nonatomic, assign, readonly) uint32_t stageIndex;
@property (nonatomic, assign, readonly) uint32_t frameIndex;
@property (nonatomic, assign, readonly) uint32_t seed;
@property (nonatomic, assign, readonly) NSRange objectRange;
@property (nonatomic, assign, readonly) NSRange markupRange;

+(id) basementStage;
+(id) menuMainStage;
+(id) stageWithIndex:(uint32_t)index
          baseHeight:(NSUInteger)baseHeight
                seed:(uint32_t)seed;

-(NSArray*) collideItemWithPosition:(CGPoint)position
                           velocity:(CGPoint)velocity
                              bound:(CGRect)bound;
-(MSpriteTowerStepBase*) collideStepWithPosition:(CGPoint)position
                                        velocity:(CGPoint*)velocity
                                           bound:(CGRect)bound
                                      frameIndex:(int32_t)frameIndex;
-(void) updateToFrame:(int32_t)frame;
@end
