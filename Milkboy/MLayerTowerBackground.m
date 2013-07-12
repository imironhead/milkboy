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
        self.sprites = [CCSpriteBatchNode batchNodeWithFile:@"Texture/back.pvr.ccz" capacity:20];

        [self addChild:self.sprites];

        //--frames
        NSArray* namesBackground =
        @[
            @"back_background_00.png",
            @"back_background_01.png",
            @"back_background_02.png",
            @"back_background_03.png",
            @"back_background_04.png",
            @"back_background_05.png",
            @"back_background_06.png",
            @"back_background_07.png",
        ];

        NSArray* namesBasement =
        @[
            @"back_basement_00.png",
            @"back_basement_01.png",
            @"back_basement_02.png",
            @"back_basement_03.png",
            @"back_basement_04.png",
        ];

        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];

        self.framesBackground = [NSMutableArray arrayWithCapacity:namesBackground.count];

        self.framesBasement   = [NSMutableArray arrayWithCapacity:namesBasement.count];

        for (NSString* name in namesBackground)
        {
            [self.framesBackground addObject:[cache spriteFrameByName:name]];
        }

        for (NSString* name in namesBasement)
        {
            [self.framesBasement addObject:[cache spriteFrameByName:name]];
        }

        //
        CCSprite* sprite;

        float y = -64.0f;

        self.magic = -2;

        for (int i = -2; i < 16; ++i, y += 32.0f)
        {
            //--background
            sprite = [CCSprite new];

            sprite.position = CGPointMake(0.0f, y);

            sprite.anchorPoint = ccp(0.0f, 0.0f);
            sprite.scale = 2.0f;

            if (i >= 0)
            {
                sprite.displayFrame = self.framesBackground[(i + i % 7) % 8];
            }
            else if (i == -1)
            {
                sprite.displayFrame = self.framesBasement[0];
            }
            else
            {
                sprite.displayFrame = self.framesBasement[1 + (-i - 1) % 4];
            }

            [self.sprites addChild:sprite z:0];
        }
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) update
{
    //--base on position of parent layer
    CGPoint pos = self.parent.position;

    int32_t magic = (pos.y >= 64.0f) ? -2 : (int32_t)floorf((64.0f - pos.y) / 32.0f) - 2;

    if (self.magic != magic)
    {
        self.magic = magic;

        float b = (float)(32 * (magic + 2) - 64);

        for (CCSprite* sprite in self.sprites.children)
        {
            sprite.position = CGPointMake(0.0f, b);

            if (magic >= 0)
            {
                sprite.displayFrame = self.framesBackground[(magic + magic % 7) % 8];
            }
            else if (magic == -1)
            {
                sprite.displayFrame = self.framesBasement[0];
            }
            else
            {
                sprite.displayFrame = self.framesBasement[1 + (-magic - 1) % 4];
            }

            b += 32.0f;

            magic += 1;
        }
    }
}

//------------------------------------------------------------------------------
@end
