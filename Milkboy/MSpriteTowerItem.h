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
@interface MSpriteTowerItemBase : CCSprite
@property (nonatomic, assign, readonly) MTowerObjectType type;
@property (nonatomic, assign, readonly) uint32_t uiid;
@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, assign, readonly) NSRange range;

+(id) itemWithType:(MTowerObjectType)type
          position:(CGPoint)position
              uiid:(uint32_t)uiid
              seed:(uint32_t)seed;

-(void) updateToFrame:(int32_t)frame;
-(void) collected;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerItemBox : MSpriteTowerItemBase
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerItemCat : MSpriteTowerItemBase
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSpriteTowerItemMilk : MSpriteTowerItemBase
@end

