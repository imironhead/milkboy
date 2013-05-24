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


//------------------------------------------------------------------------------
@class GKMatch;
@class MBoyLocal;

//------------------------------------------------------------------------------
@interface MLayerTower : CCLayer
@property (nonatomic, strong, readonly) MBoyLocal* boyLocal;

@property (nonatomic, assign, readonly) float waterLevel;
@property (nonatomic, assign, readonly) float waterSpeed;

+(id) layerWithMatch:(GKMatch*)match;
@end
