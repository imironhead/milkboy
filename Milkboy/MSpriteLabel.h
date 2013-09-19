//
//  MSpriteLabel.h
//  Milkboy
//
//  Created by iRonhead on 9/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@interface MSpriteLabel : CCSprite
@property (nonatomic, strong) NSString* text;

+(id) labelWithTable:(NSDictionary*)table space:(float)space;
+(id) labelWithTable:(NSDictionary*)table space:(float)space text:(NSString*)text;
@end
