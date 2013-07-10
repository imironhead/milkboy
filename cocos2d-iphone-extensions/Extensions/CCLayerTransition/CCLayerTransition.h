//
//  CCLayerTransition.h
//  Milkboy
//
//  Created by iRonhead on 7/5/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"


//------------------------------------------------------------------------------
@interface CCLayerTransitionCrossFade : CCLayer
+(id) layerWithPrevLayer:(CCLayer*)prevLayer
               nextLayer:(CCLayer*)nextLayer
                duration:(ccTime)duration;
@end
