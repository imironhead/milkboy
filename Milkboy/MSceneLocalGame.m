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
@property (nonatomic, strong) CCLabelAtlas* labelDistance;
@property (nonatomic, strong) CCLabelAtlas* labelMilkCount;
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

        self.labelDistance =
            [CCLabelAtlas labelWithString:@"0 m"
                              charMapFile:@"fps_images.png"
                                itemWidth:12
                               itemHeight:32
                             startCharMap:'.'];

        self.labelDistance.position = ccp(80.0f, 450.0f);
        self.labelDistance.color = ccc3(0xff, 0xff, 0x80);

        [layerMenu addChild:self.labelDistance z:0];

        self.labelMilkCount =
            [CCLabelAtlas labelWithString:@"0 Milk"
                              charMapFile:@"fps_images.png"
                                itemWidth:12
                               itemHeight:32
                             startCharMap:'.'];

        self.labelMilkCount.position = ccp(240.0f, 450.0f);
        self.labelMilkCount.color = ccc3(0x80, 0x80, 0xff);

        [layerMenu addChild:self.labelMilkCount z:0];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) update:(ccTime)elapsed
{
    int32_t f = (int32_t)floorf(self.layerTower.boyLocal.position.y / 30.0f);

    self.labelDistance.string = [NSString stringWithFormat:@"%d", f];

    self.labelMilkCount.string = [NSString stringWithFormat:@"%d", self.layerTower.boyLocal.milkCount];
}

//------------------------------------------------------------------------------
@end
