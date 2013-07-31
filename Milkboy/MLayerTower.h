//
//  MLayerTower.h
//  Milkboy
//
//  Created by iRonhead on 7/8/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"


//------------------------------------------------------------------------------
@interface MLayerTower : CCLayer
@property (nonatomic, assign, readonly) MTowerType type;

-(void) resume;
-(void) pause;
-(void) transformToType:(MTowerType)type;
@end
