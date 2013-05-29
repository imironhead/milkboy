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

        //
        CCSprite* sprite;

        for (int i = 0; i < 20; ++i)
        {
            sprite = [CCSprite spriteWithSpriteFrameName:@"back.png"];

            sprite.position = CGPointMake(
                160.0f,
                16.0f + 32.0f * (float)i);

            [self.spritesBack addChild:sprite z:0];
        }

        //
        for (int i = 0; i < 20; ++i)
        {
            sprite = [CCSprite spriteWithSpriteFrameName:@"wall_01.png"];

            sprite.position = CGPointMake(-20.0f, 16.0f + 32.0f * (float)i);

            [self.spritesWall addChild:sprite z:0];

            sprite = [CCSprite spriteWithSpriteFrameName:@"wall_02.png"];

            sprite.position = CGPointMake(330.0f, 16.0f + 32.0f * (float)i);

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

        if (cameraPosition.y + 240.0f >= spriteT.position.y)
        {
            float bottom = 16.0f + 32.0f * floorf((cameraPosition.y - 256.0f) / 32.0f);
            float b = bottom;

            for (CCSprite* sprite in self.spritesBack.children)
            {
                sprite.position = CGPointMake(160.0f, b);

                b += 32.0f;
            }

            int32_t k = 0;

            b = bottom;

            for (CCSprite* sprite in self.spritesWall.children)
            {
                k += 1;

                if (k & 1)
                {
                    sprite.position = CGPointMake(-20.0f, b);
                }
                else
                {
                    sprite.position = CGPointMake(330.0f, b);

                    b += 32.0f;
                }
            }
        }
        else if (cameraPosition.y - 240.0f <= spriteB.position.y)
        {
            float bottom = 16.0f + 32.0f * floorf((cameraPosition.y - 256.0f) / 32.0f);
            float b = bottom;

            for (CCSprite* sprite in self.spritesBack.children)
            {
                sprite.position = CGPointMake(160.0f, b);

                b += 32.0f;
            }

            int32_t k = 0;

            b = bottom;

            for (CCSprite* sprite in self.spritesWall.children)
            {
                k += 1;

                if (k & 1)
                {
                    sprite.position = CGPointMake(-20.0f, b);
                }
                else
                {
                    sprite.position = CGPointMake(330.0f, b);

                    b += 32.0f;
                }
            }
        }
    }
}

//------------------------------------------------------------------------------
@end
