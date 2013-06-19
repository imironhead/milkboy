//
//  MSceneMenuMain.m
//  Milkboy
//
//  Created by iRonhead on 6/19/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerMenuGift.h"
#import "MLayerMenuOption.h"
#import "MLayerMenuPlay.h"
#import "MSceneMenuMain.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MLayerMenuMain ()
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface MSceneMenuMain ()
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MLayerMenuMain
//------------------------------------------------------------------------------
-(id) init
{
    NSArray* layers = @[
        [MLayerMenuPlay new],
        [MLayerMenuOption new],
        [MLayerMenuGift new]];

    self = [super initWithLayers:layers widthOffset:0.0f];

    if (self)
    {
        self.minimumTouchLengthToSlide = 10.0f;
        self.minimumTouchLengthToChangePage = 30.0f;
    }

    return self;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@implementation MSceneMenuMain
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        [self addChild:[MLayerMenuMain new]];
    }

    return self;
}

//------------------------------------------------------------------------------
@end
