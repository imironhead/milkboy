//
//  MLayerTowerObjects.h
//  Milkboy
//
//  Created by iRonhead on 7/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"
#import "MLayerTowerBoy.h"
#import "MSpriteTowerItem.h"
#import "MSpriteTowerStep.h"


//------------------------------------------------------------------------------
@interface MLayerTowerObjects : CCLayer
@property (nonatomic, strong, readonly) NSArray* steps;
@property (nonatomic, strong, readonly) NSArray* items;
@property (nonatomic, assign, readonly) float deadLine;
@property (nonatomic, assign) BOOL canClimb;
@property (nonatomic, assign) float padding;

-(NSArray*) collideItemWithPosition:(CGPoint)position
                           velocity:(CGPoint)velocity
                              bound:(CGRect)bound;
-(MSpriteTowerStepBase*) collideStepWithPosition:(CGPoint)position
                                        velocity:(CGPoint*)velocity
                                           bound:(CGRect)bound
                                      frameIndex:(int32_t)frameIndex;
-(void) updateDeadLineWithBoy:(MLayerTowerBoy*)boy;
-(void) updateToFrame:(int32_t)frame;
-(void) transformToType:(MTowerType)type;
@end
