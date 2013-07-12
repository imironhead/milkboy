//
//  MLayerTowerWall.m
//  Milkboy
//
//  Created by iRonhead on 7/12/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTowerWall.h"


//------------------------------------------------------------------------------
@interface MLayerTowerWall ()
@property (nonatomic, strong) CCSpriteBatchNode* sprites;
@property (nonatomic, assign) int32_t magic;
@end

//------------------------------------------------------------------------------
@implementation MLayerTowerWall
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--batch node
        self.sprites = [CCSpriteBatchNode batchNodeWithFile:@"Texture/wall.pvr.ccz" capacity:20];

        [self addChild:self.sprites];

        //--build wall from 0
        self.magic = 0;

        //--sprites
        CCSprite* sprite;

        float y = 0.0f;

        for (int i = 0; i < 20; ++i, y += 32.0f)
        {
            //--left wall
            sprite = [CCSprite spriteWithSpriteFrameName:@"wall_01.png"];

            sprite.position = CGPointMake(0.0f, y);
            sprite.anchorPoint = ccp(1.0f, 0.0f);

            [self.sprites addChild:sprite z:0];

            //--right wall
            sprite = [CCSprite spriteWithSpriteFrameName:@"wall_02.png"];

            sprite.position = CGPointMake(310.0f, y);
            sprite.anchorPoint = ccp(0.0f, 0.0f);

            sprite.flipX = TRUE;

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

    int32_t magic = (pos.y > 0.0f) ? 0 : (int32_t)floorf(pos.y / -32.0f);

    if (self.magic != magic)
    {
        self.magic = magic;

        int32_t k = 0;

        float b = (float)(32 * magic);

        for (CCSprite* sprite in self.sprites.children)
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

//------------------------------------------------------------------------------
@end
