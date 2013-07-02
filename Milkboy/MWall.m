//
//  MWall.m
//  Milkboy
//
//  Created by iRonhead on 5/27/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MWall.h"


//------------------------------------------------------------------------------
@interface MWall ()
@property (nonatomic, strong, readwrite) CCSpriteBatchNode* spritesBack;
@property (nonatomic, strong, readwrite) CCSpriteBatchNode* spritesWall;
@property (nonatomic, strong) NSMutableArray* framesBackground;
@property (nonatomic, strong) NSMutableArray* framesBasement;
@end

//------------------------------------------------------------------------------
@implementation MWall
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--batch node
        self.spritesBack = [CCSpriteBatchNode batchNodeWithFile:@"Texture/back.pvr.ccz" capacity:20];
        self.spritesWall = [CCSpriteBatchNode batchNodeWithFile:@"Texture/wall.pvr.ccz" capacity:40];

        [self.spritesBack.texture setAliasTexParameters];
        [self.spritesWall.texture setAliasTexParameters];

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

        float y = -256.0f;

        for (int i = -8; i < 12; ++i, y += 32.0f)
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

            [self.spritesBack addChild:sprite z:0];

            //--left wall
            sprite = [CCSprite spriteWithSpriteFrameName:@"wall_01.png"];

            sprite.position = CGPointMake(0.0f, y);
            sprite.anchorPoint = ccp(1.0f, 0.0f);

            [self.spritesWall addChild:sprite z:0];

            //--right wall
            sprite = [CCSprite spriteWithSpriteFrameName:@"wall_02.png"];

            sprite.position = CGPointMake(310.0f, y);
            sprite.anchorPoint = ccp(0.0f, 0.0f);

            sprite.flipX = TRUE;

            [self.spritesWall addChild:sprite z:0];
        }
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) setCameraPosition:(CGPoint)cameraPosition
{
    if (!CGPointEqualToPoint(self->_cameraPosition, cameraPosition))
    {
        self->_cameraPosition = cameraPosition;

        CCSprite* spriteT = [self.spritesBack.children lastObject];
        CCSprite* spriteB = [self.spritesBack.children objectAtIndex:0];

        if ((cameraPosition.y + 240.0f >= spriteT.position.y) ||
            (cameraPosition.y - 240.0f <= spriteB.position.y))
        {
            int32_t k = 0;
            int32_t q = floorf((cameraPosition.y - 256.0f) / 32.0f);

            float bottom = 32.0f * (float)q;
            float b = bottom;

            for (CCSprite* sprite in self.spritesBack.children)
            {
                sprite.position = CGPointMake(0.0f, b);

                if (q >= 0)
                {
                    sprite.displayFrame = self.framesBackground[(q + q % 7) % 8];
                }
                else if (q == -1)
                {
                    sprite.displayFrame = self.framesBasement[0];
                }
                else
                {
                    sprite.displayFrame = self.framesBasement[1 + (-q - 1) % 4];
                }

                b += 32.0f;

                q += 1;
            }

            b = bottom;

            for (CCSprite* sprite in self.spritesWall.children)
            {
                k += 1;

                if (k & 1)
                {
                    sprite.position = CGPointMake(0.0f, b);
                }
                else
                {
                    sprite.position = CGPointMake(310.0f, b);

                    b += 32.0f;
                }
            }
        }
    }
}

//------------------------------------------------------------------------------
@end
