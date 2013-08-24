//
//  MLayerTowerBrick.m
//  Milkboy
//
//  Created by iRonhead on 7/12/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTowerBackground.h"


//------------------------------------------------------------------------------
@interface MLayerTowerBackground ()
@property (nonatomic, strong) CCSpriteBatchNode* sprites;
@property (nonatomic, strong) NSMutableArray* framesBackground;
@property (nonatomic, strong) NSMutableArray* framesBasement;
@property (nonatomic, assign) int32_t magic;
@property (nonatomic, strong) NSMutableArray* floors;
@end

//------------------------------------------------------------------------------
@implementation MLayerTowerBackground
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--batch node
        self.sprites = [CCSpriteBatchNode batchNodeWithFile:@"Texture/back.pvr.ccz" capacity:10];

        [self addChild:self.sprites];

        //--sprite frame cache
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];

        //--basement frames
        NSArray* namesBasement =
        @[
            @"back_basement_00.png",
            @"back_basement_01.png",
        ];

        self.framesBasement   = [NSMutableArray arrayWithCapacity:namesBasement.count];

        for (NSString* name in namesBasement)
        {
            [self.framesBasement addObject:[cache spriteFrameByName:name]];
        }

        //--background frames
        uint32_t i;
        uint32_t j;

        self.framesBackground = [NSMutableArray array];

        for (i = 0; i < 3; ++i)
        {
            NSMutableArray* cato = [NSMutableArray array];

            [self.framesBackground addObject:cato];

            for (j = 0; j < 8; ++j)
            {
                [cato addObject:
                    [cache spriteFrameByName:
                        [NSString stringWithFormat:@"wallpaper_%02d_%02d.png", i, j]]];
            }

            [cato addObject:
                [cache spriteFrameByName:
                    [NSString stringWithFormat:@"wallpaper_%02d_bottom.png", i]]];

            [cato addObject:
                [cache spriteFrameByName:
                    [NSString stringWithFormat:@"wallpaper_%02d_top.png", i]]];
        }

        //--setup 1st floor
        self.floors = [NSMutableArray array];

        NSMutableArray* _floor = [NSMutableArray array];

        [self.floors addObject:_floor];

        [_floor addObject:@0];

        NSMutableArray* tiles = [NSMutableArray array];

        [_floor addObject:tiles];

        NSArray* cato = self.framesBackground[arc4random_uniform(self.framesBackground.count)];

        [tiles addObject:cato[8]];

        for (uint32_t m = 2; m < MGAMECONFIG_BACK_COUNT_TILE_PER_FLOOR; ++m)
        {
            [tiles addObject:cato[arc4random_uniform(8)]];
        }

        [tiles addObject:cato[9]];

        //
        CCSprite* sprite;

        float y = -64.0f;

        for (int i = -1; i < 9; ++i, y += 64.0f)
        {
            //--background
            sprite = [CCSprite new];

            sprite.position = CGPointMake(0.0f, y);

            sprite.anchorPoint = ccp(0.0f, 0.0f);
            sprite.scale = 2.0f;

            if (i >= 0)
            {
                sprite.displayFrame = tiles[i];
            }
            else if (i == -1)
            {
                sprite.displayFrame = self.framesBasement[0];
            }
            else
            {
                sprite.displayFrame = self.framesBasement[1];
            }

            [self.sprites addChild:sprite z:1];
        }

        //--
        self.magic = -1;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) setPaddingState:(MTowerPaddingState)paddingState
{
    switch (paddingState)
    {
    case MTowerPaddingStateNone:
        {
        }
        break;
    case MTowerPaddingStatePadded:
        {
            NSMutableArray* floor_0 = self.floors[0];
            NSMutableArray* floor_1 = [NSMutableArray array];

            //--copy tiles in floor 0 to floor 1 since padding
            [floor_1 addObject:@1];

            NSMutableArray* tiles = [NSMutableArray array];

            [floor_1 addObject:tiles];

            for (id frame in (NSArray*)floor_0[1])
            {
                [tiles addObject:frame];
            }

            //--new random tiles for floor 0
            NSArray* cato = self.framesBackground[arc4random_uniform(self.framesBackground.count)];

            tiles = floor_0[1];

            [tiles removeAllObjects];

            [tiles addObject:cato[8]];

            for (uint32_t m = 2; m < MGAMECONFIG_BACK_COUNT_TILE_PER_FLOOR; ++m)
            {
                [tiles addObject:cato[arc4random_uniform(8)]];
            }

            [tiles addObject:cato[9]];

            //
            [self.floors removeAllObjects];

            [self.floors addObject:floor_0];
            [self.floors addObject:floor_1];
        }
        break;
    case MTowerPaddingStateRemoved:
        {
            int32_t indexB = ((       - self.parent.position.y) / MGAMECONFIG_BACK_HEIGHT_FLOOR);
            int32_t indexT = ((480.0f - self.parent.position.y) / MGAMECONFIG_BACK_HEIGHT_FLOOR);
            int32_t indexK = [(NSNumber*)[(NSArray*)self.floors[0] objectAtIndex:0] intValue];

            NSMutableArray* floorsT = [NSMutableArray array];

            NSMutableArray* floor_0 = self.floors[indexB - indexK];

            floor_0[0] = @0;

            [floorsT addObject:floor_0];

            if (indexB != indexT)
            {
                NSMutableArray* floor_1 = self.floors[indexT - indexK];

                floor_1[0] = @1;

                [floorsT addObject:floor_1];
            }

            self.floors = floorsT;
        }
        break;
    }
}

//------------------------------------------------------------------------------
-(void) update
{
    //--base on position of parent layer
    CGPoint pos = self.parent.position;

    int32_t magic;

    if (pos.y >= 64.0f)
    {
        magic = -1;
    }
    else
    {
        magic = (int32_t)floorf((64.0f - pos.y) / 64.0f) - 1;
    }

    if (self.magic != magic)
    {
        self.magic = magic;

        //
        float b = (float)(magic * 64);

        for (CCSprite* sprite in self.sprites.children)
        {
            sprite.position = CGPointMake(0.0f, b);

            if (magic >= 0)
            {
                sprite.displayFrame = [self displayFrameOfIndex:magic];
            }
            else if (magic == -1)
            {
                sprite.displayFrame = self.framesBasement[0];
            }
            else
            {
                sprite.displayFrame = self.framesBasement[1];
            }

            b += 64.0f;

            magic += 1;
        }

        [self removeNonusedFloor];
    }
}

//------------------------------------------------------------------------------
-(CCSpriteFrame*) displayFrameOfIndex:(int32_t)index
{
    int32_t iFloor = index / MGAMECONFIG_BACK_COUNT_TILE_PER_FLOOR;
    int32_t iTile  = index % MGAMECONFIG_BACK_COUNT_TILE_PER_FLOOR;

    //--supplement
    int32_t iLast = [(NSNumber*)[(NSArray*)self.floors.lastObject objectAtIndex:0] intValue];

    while (iLast <= iFloor)
    {
        iLast += 1;

        //
        NSMutableArray* _floor = [NSMutableArray array];

        [self.floors addObject:_floor];

        [_floor addObject:[NSNumber numberWithInt:iLast]];

        NSMutableArray* tiles = [NSMutableArray array];

        [_floor addObject:tiles];

        NSArray* cato = self.framesBackground[arc4random_uniform(self.framesBackground.count)];

        [tiles addObject:cato[8]];

        for (uint32_t m = 2; m < MGAMECONFIG_BACK_COUNT_TILE_PER_FLOOR; ++m)
        {
            [tiles addObject:cato[arc4random_uniform(8)]];
        }

        [tiles addObject:cato[9]];
    }

    //--find requested frame
    int32_t iFirst = [(NSNumber*)[(NSArray*)self.floors[0] objectAtIndex:0] intValue];

    return (CCSpriteFrame*)[(NSArray*)[(NSArray*)self.floors[iFloor - iFirst] objectAtIndex:1] objectAtIndex:iTile];
}

//------------------------------------------------------------------------------
-(void) removeNonusedFloor
{
    CGPoint pos = self.parent.position;

    int32_t index = (int32_t)floorf((64.0f - pos.y) / MGAMECONFIG_BACK_HEIGHT_FLOOR);

    index = (index < 0 ? -1 : index - 1);

    NSMutableArray* temp = [NSMutableArray array];

    for (NSArray* floor in self.floors)
    {
        if ([(NSNumber*)floor[0] intValue] >= index)
        {
            [temp addObject:floor];
        }
    }

    if (temp.count < self.floors.count)
    {
        NSLog(@"floors: %d", temp.count);
    }

    self.floors = temp;
}

//------------------------------------------------------------------------------
@end
