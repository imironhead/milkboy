//
//  MLayerTowerBrick.h
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
@interface MLayerTowerBackground : CCLayer
@property (nonatomic, assign) MTowerPaddingState paddingState;

-(void) update;
@end
