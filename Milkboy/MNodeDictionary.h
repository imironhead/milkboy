//
//  MNodeDictionary.h
//  Milkboy
//
//  Created by iRonhead on 9/18/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@interface MNodeDictionary : CCNode
@property (nonatomic, strong, readonly) NSDictionary* info;

+(id) nodeWithTag:(NSInteger)tag info:(NSDictionary*)info;
@end
