//
//  MType.h
//  Milkboy
//
//  Created by iRonhead on 5/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


//------------------------------------------------------------------------------
typedef struct _MVisiblityRange
{
    float   upperBound;
    float   lowerBound;
} MVisibilityRange, MCollisionRange;

//------------------------------------------------------------------------------
static inline MCollisionRange MCollisionRangeMake(float lowerBound, float upperBound);

//------------------------------------------------------------------------------
static inline MCollisionRange MCollisionRangeMake(float lowerBound, float upperBound)
{
    MCollisionRange range =
    {
        .lowerBound = lowerBound,
        .upperBound = upperBound,
    };

    return range;
}

