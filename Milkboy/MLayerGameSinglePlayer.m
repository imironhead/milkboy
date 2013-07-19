//
//  MLayerGameSinglePlayer.m
//  Milkboy
//
//  Created by iRonhead on 7/9/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MConstant.h"
#import "MLayerGameSinglePlayer.h"


//------------------------------------------------------------------------------
@implementation MLayerGameSinglePlayer
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        self.tag = MTagLayerGameSinglePlayer;
    }

    return self;
}

//------------------------------------------------------------------------------
@end
