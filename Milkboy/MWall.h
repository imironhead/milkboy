//
//  MWall.h
//  Milkboy
//
//  Created by iRonhead on 5/27/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@interface MWall : NSObject
@property (nonatomic, strong, readonly) CCSpriteBatchNode* spritesBack;
@property (nonatomic, strong, readonly) CCSpriteBatchNode* spritesWall;
@property (nonatomic, assign) CGPoint cameraPosition;
@end
