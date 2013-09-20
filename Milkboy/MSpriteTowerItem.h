//
//  MSpriteTowerItem.h
//  Milkboy
//
//  Created by iRonhead on 5/29/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerItem : CCSprite
@property (nonatomic, assign, readonly) MTowerObjectType type;
@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, assign, readonly) uint32_t parameter;

+(id)   factoryCreateItemWithType:(MTowerObjectType)type position:(CGPoint)position token:(uint32_t)token;
+(void) factoryDeleteItem:(MSpriteTowerItem*)item;

-(void) updateToFrame:(int32_t)frame;
-(void) collectedWithFlag:(NSNumber*)flag;
-(void) pad:(float)pad;
@end


