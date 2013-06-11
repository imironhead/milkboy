//
//  MWater.h
//  Milkboy
//
//  Created by iRonhead on 6/11/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@interface MWater : NSObject
@property (nonatomic, strong, readonly) CCSpriteBatchNode* sprites;
@property (nonatomic, assign, readonly) int32_t level;
@property (nonatomic, assign) CGPoint cameraPosition;

-(void) jumpToFrame:(int32_t)frame;
@end
