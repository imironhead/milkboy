//
//  CCLayerTransition.m
//  Milkboy
//
//  Created by iRonhead on 7/5/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "CCLayerTransition.h"


//------------------------------------------------------------------------------
@interface CCLayerTransitionCrossFade()
@property (nonatomic, strong) CCLayer* nextLayer;
@end

//------------------------------------------------------------------------------
@implementation CCLayerTransitionCrossFade
//------------------------------------------------------------------------------
+(id) layerWithPrevLayer:(CCLayer*)prevLayer
               nextLayer:(CCLayer*)nextLayer
                duration:(ccTime)duration
{
    return [[CCLayerTransitionCrossFade alloc] initWithPrevLayer:prevLayer nextLayer:nextLayer duration:duration];
}

//------------------------------------------------------------------------------
-(id) initWithPrevLayer:(CCLayer*)prevLayer
              nextLayer:(CCLayer*)nextLayer
               duration:(ccTime)duration
{
    self = [super init];

    if (self)
    {
        self.nextLayer = nextLayer;

        //--
        CGSize size = [[CCDirector sharedDirector] winSize];

        //--texture for prev layer
        CCRenderTexture* prevTexture = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];

        prevTexture.sprite.anchorPoint= ccp(0.5f,0.5f);
        prevTexture.position = ccp(size.width/2, size.height/2);
        prevTexture.anchorPoint = ccp(0.5f,0.5f);

        [prevTexture beginWithClear:0.0f g:0.0f b:0.0f a:0.0f];
        [prevLayer visit];
        [prevTexture end];

        //--texture for next layer
        CCRenderTexture* nextTexture = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];

        nextTexture.sprite.anchorPoint= ccp(0.5f,0.5f);
        nextTexture.position = ccp(size.width/2, size.height/2);
        nextTexture.anchorPoint = ccp(0.5f,0.5f);

        [nextTexture beginWithClear:0.0f g:0.0f b:0.0f a:0.0f];
        [nextLayer visit];
        [nextTexture end];

        //--create blend functions
        ccBlendFunc blend = {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA};

        //--set blendfunctions
        [prevTexture.sprite setBlendFunc:blend];
        [nextTexture.sprite setBlendFunc:blend];

        //--add render textures to the layer
        [self addChild:prevTexture];
        [self addChild:nextTexture];

        //--initial opacity:
        [prevTexture.sprite setOpacity:255];
        [nextTexture.sprite setOpacity:0];

        //--
        [prevLayer removeFromParentAndCleanup:TRUE];

        //--actions
        [prevTexture.sprite runAction:[CCFadeTo actionWithDuration:duration opacity:0]];

        CCActionInterval* actionForNextLayer = [CCSequence actions:
            [CCFadeTo actionWithDuration:duration opacity:255],
            [CCCallFunc actionWithTarget:self selector:@selector(finish)],
            nil];

        [nextTexture.sprite runAction:actionForNextLayer];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) finish
{
	[self schedule:@selector(addNextLayer:) interval:0];
}

//------------------------------------------------------------------------------
-(void) addNextLayer:(ccTime) dt
{
    [self.parent addChild:self.nextLayer];

    [self removeFromParentAndCleanup:TRUE];
}

//------------------------------------------------------------------------------
@end
