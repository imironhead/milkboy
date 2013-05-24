//
//  ULine.h
//  UEngineTestBed
//
//  Created by iRonhead on 3/25/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UVector2.h"


//------------------------------------------------------------------------------
typedef struct _ULineSegment2d
{
    UVector2   b;
    UVector2   e;
} ULineSegment2d;

//------------------------------------------------------------------------------
static inline ULineSegment2d ULineSegment2dMake(UVector2 begin, UVector2 end);

//------------------------------------------------------------------------------
static inline ULineSegment2d ULineSegment2dMake(UVector2 begin, UVector2 end)
{
    ULineSegment2d s = {.b = begin, .e = end};

    return s;
}
