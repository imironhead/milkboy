//
//  MTowerItem.h
//  Milkboy
//
//  Created by iRonhead on 5/29/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MConstant.h"
#import "MType.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerItemBase : NSObject
@property (nonatomic, strong, readonly) CCSprite* sprite;
@property (nonatomic, assign, readonly) MTowerObjectType type;
@property (nonatomic, assign, readonly) uint32_t uiid;
@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, assign, readonly) CGRect boundCollision;
@property (nonatomic, assign, readonly) MCollisionRange rangeVisiblity;
@property (nonatomic, assign, readonly) MCollisionRange rangeCollision;

+(id) itemWithPosition:(CGPoint)position
                  uiid:(uint32_t)uiid
                  seed:(uint32_t)seed;
+(id) itemWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed;

-(void) jumpToFrame:(int32_t)frame refresh:(BOOL)refresh;
-(void) collected;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MTowerItemMilk : MTowerItemBase
@end

