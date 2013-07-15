//
//  MLayerTowerStages.m
//  Milkboy
//
//  Created by iRonhead on 7/12/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MLayerTowerStages.h"
#import "MSpriteTowerItem.h"
#import "MSpriteTowerStage.h"
#import "MSpriteTowerStep.h"


//------------------------------------------------------------------------------
@interface MLayerTowerStages ()
@property (nonatomic, readwrite, strong) NSArray* stagesInTower;
@property (nonatomic, readwrite, strong) NSArray* stagesVisible;
@property (nonatomic, strong) CCSpriteBatchNode* sprites;
@property (nonatomic, assign) MTowerType type;
@property (nonatomic, assign) int32_t magic;
@end

//------------------------------------------------------------------------------
@implementation MLayerTowerStages
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--
        self.type = MTowerTypeMenuMain;

        self.magic = 1;

        //--batch nodes
        self.sprites = [CCSpriteBatchNode batchNodeWithFile:@"Texture/step.pvr.ccz"];

        [self addChild:self.sprites];

        //--basement
        MSpriteTowerStage* stageBase = [MSpriteTowerStage basementStage];

        self.stagesInTower = [NSMutableArray arrayWithObject:stageBase];
        self.stagesVisible = [NSMutableArray arrayWithObject:stageBase];

        //--first stage for main menu
        MSpriteTowerStage* stage1st = [MSpriteTowerStage menuMainStage];

        [(NSMutableArray*)self.stagesInTower addObject:stage1st];
        [(NSMutableArray*)self.stagesVisible addObject:stage1st];

        //--
        [self.sprites addChild:stageBase];
        [self.sprites addChild:stage1st];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) updateToFrame:(int32_t)frame
{
    if (self.type != MTowerTypeGameSinglePlayer)
    {
        return;
    }

    //--base on position of parent layer
    CGPoint pos = self.parent.position;

    int32_t magic = 0;

    NSUInteger lowerBound = (pos.y >= -1.0f) ? 1 : (NSUInteger)(-pos.y);

    NSRange range;

    MSpriteTowerStage* stage;

    for (stage in self.stagesVisible)
    {
        range = stage.markupRange;

        if ((lowerBound >= range.location) &&
            (lowerBound <= NSMaxRange(range)))
        {
            magic = stage.stageIndex;

            break;
        }
    }

    if (!magic)
    {
        for (stage in self.stagesInTower)
        {
            range = stage.markupRange;

            if ((lowerBound >= range.location) &&
                (lowerBound <= NSMaxRange(range)))
            {
                magic = stage.stageIndex;

                break;
            }
        }

        if (!magic)
        {
            magic = self.stagesInTower.count;
        }
    }

    if (magic + 1 >= self.stagesInTower.count)
    {
        uint32_t k = self.stagesInTower.count;
        uint32_t j = magic + 2;

        for (; k < j; ++k)
        {
            stage = [MSpriteTowerStage stageWithIndex:k
                                     baseHeight:NSMaxRange(((MSpriteTowerStage*)self.stagesInTower[k - 1]).markupRange)
                                           seed:arc4random() & 0x0000ffff];

            [(NSMutableArray*)self.stagesInTower addObject:stage];

            [(NSMutableArray*)self.stagesVisible addObject:stage];

            [self.sprites addChild:stage];
        }
    }

    if (self.magic != magic)
    {
        self.magic = magic;

        [self.sprites removeAllChildrenWithCleanup:YES];

        [(NSMutableArray*)self.stagesVisible removeAllObjects];

        uint32_t k = (magic > 1) ? magic - 1 : 0;
        uint32_t j = magic + 2;

        for (; k < j; ++k)
        {
            [(NSMutableArray*)self.stagesVisible addObject:self.stagesInTower[k]];

            [self.sprites addChild:self.stagesInTower[k]];
        }
    }

    //--update visible range
    for (stage in self.stagesVisible)
    {
        [stage updateToFrame:frame];
    }
}

//------------------------------------------------------------------------------
-(void) transformToType:(MTowerType)type duration:(ccTime)duration
{
    MSpriteTowerStage* stageBasement = self.stagesInTower[0];
    MSpriteTowerStage* stage1stFloor = (self.stagesInTower.count > 1) ? self.stagesInTower[1] : nil;

    [(NSMutableArray*)self.stagesInTower removeAllObjects];
    [(NSMutableArray*)self.stagesVisible removeAllObjects];

    [(NSMutableArray*)self.stagesInTower addObject:stageBasement];
    [(NSMutableArray*)self.stagesVisible addObject:stageBasement];

    [self.sprites removeAllChildrenWithCleanup:YES];

    [self.sprites addChild:stageBasement];
    [self.sprites addChild:stage1stFloor];

    //--new stage
    MSpriteTowerStage* stageNew = [MSpriteTowerStage stageWithIndex:1 baseHeight:0 seed:0];

    [(NSMutableArray*)self.stagesInTower addObject:stageNew];
    [(NSMutableArray*)self.stagesVisible addObject:stageNew];

    [self.sprites addChild:stageNew];

    //--move all items and steps from 1st stage
    for (MSpriteTowerStepBase* step in stage1stFloor.steps)
    {
        CGPoint pos = step.position;

        pos.y = 480.0f;

        [step runAction:[CCMoveTo actionWithDuration:duration position:pos]];
    }

    for (MSpriteTowerItemBase* item in stage1stFloor.items)
    {

    }

    CCDelayTime* actionDelay = [CCDelayTime actionWithDuration:duration];

    CCCallBlock* actionFinal = [CCCallBlock actionWithBlock:^{
        for (MSpriteTowerStepBase* step in stage1stFloor.steps)
        {
            [step stopAllActions];
        }

        [self.sprites removeChild:stage1stFloor cleanup:YES];

        self.type = type;
    }];

    CCSequence* actionSequence = [CCSequence actions:actionDelay, actionFinal, nil];

    [self runAction:actionSequence];
}

//------------------------------------------------------------------------------
@end
