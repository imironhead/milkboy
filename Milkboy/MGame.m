//
//  MGame.m
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MGame.h"


//------------------------------------------------------------------------------
@interface MGame ()
//------------------------------------------------------------------------------
@property (nonatomic, strong, readwrite) NSArray* functionItem;
@property (nonatomic, strong, readwrite) NSArray* functionStep;
//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
@implementation MGame
//------------------------------------------------------------------------------
static MGame* _sharedGame = nil;

//------------------------------------------------------------------------------
+(id) sharedGame
{
    if (!_sharedGame)
    {
        _sharedGame = [MGame new];
    }

    return _sharedGame;
}

//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];

    if (self)
    {
        //--data function

        self.functionItem =

#include "data_function_item.h"


        self.functionStep =

#include "data_function_step.h"
    }

    return self;
}

//------------------------------------------------------------------------------
-(NSString*) appId
{
    return @"454949846";
}

//------------------------------------------------------------------------------
-(NSString*) urlGiftApp
{
    return [NSString stringWithFormat:@"itms-appss://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%@&productType=C&pricingParameter=STDQ&mt=8&ign-mscache=1",
                                self.appId];
}

//------------------------------------------------------------------------------
-(int32_t) weightFunctionItem
{
    return [[(NSArray*)self.functionItem.lastObject lastObject] intValue];
}

//------------------------------------------------------------------------------
-(int32_t) weightFunctionStep
{
    return [[(NSArray*)self.functionStep.lastObject lastObject] intValue];
}

//------------------------------------------------------------------------------
-(MTowerObjectType) itemWithParameter:(int32_t)parameter inStage:(uint32_t)stage
{
    NSArray* stageWeights = (stage >= self.functionItem.count) ? self.functionItem.lastObject : self.functionItem[stage];

    MTowerObjectType type = MTowerObjectTypeItemBase;

    for (NSNumber* n in stageWeights)
    {
        if (n.intValue > parameter)
        {
            break;
        }

        type += 1;
    }

    NSAssert(type < MTowerObjectTypeItemMax, @"[MGame itemWithParameter: inStage:]");

    return type;
}

//------------------------------------------------------------------------------
-(MTowerObjectType) stepWithParameter:(int32_t)parameter inStage:(uint32_t)stage
{
    NSArray* stageWeights = (stage >= self.functionStep.count) ? self.functionStep.lastObject : self.functionStep[stage];

    MTowerObjectType type = MTowerObjectTypeStepBase;

    for (NSNumber* n in stageWeights)
    {
        if (n.intValue > parameter)
        {
            break;
        }

        type += 1;
    }

    NSAssert(type < MTowerObjectTypeStepMax, @"[MGame stepWithParameter: inStage:]");

    return type;
}

//------------------------------------------------------------------------------
-(float) stepIntervalInStage:(uint32_t)stage
{
    return 30.0f + MIN(stage, 30.0f);
}

//------------------------------------------------------------------------------
@end
