//
//  MLayerTowerStages.h
//  Milkboy
//
//  Created by iRonhead on 7/12/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"


//------------------------------------------------------------------------------
@interface MLayerTowerStages : CCLayer
@property (nonatomic, readonly, strong) NSArray* stagesInTower;
@property (nonatomic, readonly, strong) NSArray* stagesVisible;

-(void) updateToFrame:(int32_t)frame;
-(void) transformToType:(MTowerType)type duration:(ccTime)duration;
@end
