//
//  MLayerGameSinglePlayer.h
//  Milkboy
//
//  Created by iRonhead on 7/9/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@interface MLayerGameSinglePlayer : CCLayer
-(void) showMenuPause:(id)sender;
-(void) showMenuScore:(id)sender;

-(void) updateHeader:(NSDictionary*)info;
@end
