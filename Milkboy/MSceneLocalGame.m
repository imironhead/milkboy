//
//  MSceneLocalGame.m
//  Milkboy
//
//  Created by iRonhead on 5/17/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MBoy.h"
#import "MLayerTower.h"
#import "MSceneLocalGame.h"


//------------------------------------------------------------------------------
@interface MSceneLocalGame()
@property (nonatomic, strong) MLayerTower* layerTower;
@property (nonatomic, strong) CCLabelAtlas* labelFloor;
@end

//------------------------------------------------------------------------------
@implementation MSceneLocalGame
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        [self scheduleUpdateWithPriority:0];

        //
        self.layerTower = [MLayerTower layerWithMatch:nil];

        [self addChild:self.layerTower z:0];

        //
        CCLayer* layerMenu = [CCLayer new];

        [self addChild:layerMenu z:1];

        self.labelFloor =
            [CCLabelAtlas labelWithString:@"1"
                              charMapFile:@"fps_images.png"
                                itemWidth:12
                               itemHeight:32
                             startCharMap:'.'];

        self.labelFloor.position = ccp(160.0f, 450.0f);
        self.labelFloor.color = ccc3(0xff, 0xff, 0x80);

        [layerMenu addChild:self.labelFloor z:0];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) update:(ccTime)elapsed
{
    int32_t f = (int32_t)ceilf(self.layerTower.boyLocal.position.y / 120.0f);

    self.labelFloor.string = [NSString stringWithFormat:@"%d", f];
}

//------------------------------------------------------------------------------
@end
