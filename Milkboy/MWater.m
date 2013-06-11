//
//  MWater.m
//  Milkboy
//
//  Created by iRonhead on 6/11/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MWater.h"


//------------------------------------------------------------------------------
@interface MWater ()
@property (nonatomic, strong, readwrite) CCSpriteBatchNode* sprites;
@property (nonatomic, assign, readwrite) int32_t level;

@property (nonatomic, strong) CCSprite* spriteWave;
@property (nonatomic, strong) CCSprite* spriteWater;
@end

//------------------------------------------------------------------------------
@implementation MWater
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--batch node
        self.sprites = [CCSpriteBatchNode batchNodeWithFile:@"Texture/water.pvr.ccz" capacity:2];

        //--nearest sampling
//        [self.sprites.texture setAliasTexParameters];

        self.sprites.visible = FALSE;

        //--wave sprite
        self.spriteWave = [CCSprite spriteWithSpriteFrameName:@"water_wave.png"];

        self.spriteWave.anchorPoint = ccp(0.0f, 0.0f);
        self.spriteWave.position = ccp(0.0f, 0.0f);
        self.spriteWave.opacity = 0x80;

        [self.sprites addChild:self.spriteWave z:0];

        //--water sprite
        self.spriteWater = [CCSprite spriteWithSpriteFrameName:@"water_water.png"];

        self.spriteWater.anchorPoint = ccp(0.0f, 1.0f);
        self.spriteWater.position = ccp(0.0f, 0.0f);
        self.spriteWater.opacity = 0x80;

        self.spriteWater.scale = 1000.0f;

        [self.sprites addChild:self.spriteWater z:0];

        //--
        self.level = 0;
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) jumpToFrame:(int32_t)frame
{
    self.level = frame;//(frame > 600) ? (frame - 600) : 0;

    self.sprites.visible = ((float)(self.level + 256) >= self.cameraPosition.y);

    if (self.sprites.visible)
    {
        self.spriteWave.position = ccp(0.0f, (float)self.level);

        self.spriteWater.position = ccp(0.0f, (float)self.level);
    }
}

//------------------------------------------------------------------------------
-(void) setCameraPosition:(CGPoint)cameraPosition
{
    if (CGPointEqualToPoint(self->_cameraPosition, cameraPosition))
    {
        self->_cameraPosition = cameraPosition;

        self.sprites.visible = ((float)(self.level + 256) >= cameraPosition.y);
    }
}

//------------------------------------------------------------------------------
@end
