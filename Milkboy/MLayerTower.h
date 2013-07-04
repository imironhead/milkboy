//
//  MTower.h
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
@class GKMatch;
@class MBoyLocal;
@class MWater;

//------------------------------------------------------------------------------
@interface MLayerTower : CCLayer
@property (nonatomic, strong, readonly) MBoyLocal* boyLocal;
@property (nonatomic, strong, readonly) MWater* water;
@property (nonatomic, assign, readonly) MTowerType type;

+(id) layerWithMatch:(GKMatch*)match;
+(id) layerForMainMenu;
@end
