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
@interface MSpriteTowerStep : CCSprite
@property (nonatomic, strong, readonly) NSNumber* parameter;
@property (nonatomic, assign, readonly) MTowerObjectType type;
@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, assign, readonly) NSRange range;

+(id)   factoryCreateStepWithType:(MTowerObjectType)type position:(CGPoint)position;
+(void) factoryDeleteStep:(MSpriteTowerStep*)step;

-(void) updateToFrame:(int32_t)frame;
-(void) boyJump:(MLayerTowerBoy*)boy;
-(void) boyLand:(MLayerTowerBoy*)boy;
@end


