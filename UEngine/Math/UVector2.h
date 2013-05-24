//
//  UVector.h
//  UEngineTestBed
//
//  Created by iRonhead on 2/21/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UMathTypes.h"


//------------------------------------------------------------------------------
static inline UVector2 UVector2Add(UVector2 v1, UVector2 v2);
static inline UVector2 UVector2Sub(UVector2 v1, UVector2 v2);
static inline UVector2 UVector2Make(float x, float y);
static inline UVector2 UVector2Lerp(UVector2 v1, UVector2 v2, float f);
static inline UVector2 UVector2Scale(UVector2 v, float k);
static inline UVector2 UVector2Center(UVector2 v1, UVector2 v2);
static inline UVector2 UVector2Offset(UVector2 v, float x, float y);
static inline UVector2 CGPointToUVector2(CGPoint v);

static inline CGPoint UVector2ToCGPoint(UVector2 v);
static inline BOOL UVector2EqualToUVector2(UVector2 v1, UVector2 v2);

static inline float UVector2Dot(UVector2 v1, UVector2 v2);
static inline float UVector2Length(UVector2 v);
static inline float UVector2Distance(UVector2 v1, UVector2 v2);
static inline float UVector2LengthSqr(UVector2 v);
static inline float UVector2Direction(UVector2 v);
static inline float UVector2DistanceSqr(UVector2 v1, UVector2 v2);

//------------------------------------------------------------------------------
static inline UVector2 UVector2Add(UVector2 v1, UVector2 v2)
{
    v1.x += v2.x;
    v1.y += v2.y;

    return v1;
}

//------------------------------------------------------------------------------
static inline UVector2 UVector2Sub(UVector2 v1, UVector2 v2)
{
    v1.x -= v2.x;
    v1.y -= v2.y;

    return v1;
}

//------------------------------------------------------------------------------
static inline UVector2 UVector2Make(float x, float y)
{
    UVector2 v = {.x = x, .y = y};

    return v;
}

//------------------------------------------------------------------------------
static inline UVector2 UVector2Lerp(UVector2 v1, UVector2 v2, float f)
{
    v1.x += f * (v2.x - v1.x);
    v1.y += f * (v2.y - v1.y);

    return v1;
}

//------------------------------------------------------------------------------
static inline UVector2 UVector2Scale(UVector2 v, float k)
{
    v.x *= k;
    v.y *= k;

    return v;
}

//------------------------------------------------------------------------------
static inline UVector2 UVector2Center(UVector2 v1, UVector2 v2)
{
    v1.x = 0.5f * (v2.x + v1.x);
    v1.y = 0.5f * (v2.y + v1.y);

    return v1;
}

//------------------------------------------------------------------------------
static inline UVector2 UVector2Offset(UVector2 v, float x, float y)
{
    v.x += x;
    v.y += y;

    return v;
}

//------------------------------------------------------------------------------
static inline UVector2 CGPointToUVector2(CGPoint p)
{
    UVector2 v = {.x = p.x, .y = p.y};

    return v;
}

//------------------------------------------------------------------------------
static inline CGPoint UVector2ToCGPoint(UVector2 v)
{
    CGPoint p = {.x = v.x, .y = v.y};

    return p;
}

//------------------------------------------------------------------------------
static inline BOOL UVector2EqualToUVector2(UVector2 v1, UVector2 v2)
{
    return (v1.x == v2.x) && (v1.y == v2.y);
}

//------------------------------------------------------------------------------
static inline float UVector2Dot(UVector2 v1, UVector2 v2)
{
    return v1.x * v2.x + v1.y * v2.y;
}

//------------------------------------------------------------------------------
static inline float UVector2Length(UVector2 v)
{
    return sqrtf(v.x * v.x + v.y * v.y);
}

//------------------------------------------------------------------------------
static inline float UVector2Distance(UVector2 v1, UVector2 v2)
{
    return sqrtf((v1.x - v2.x) * (v1.x - v2.x) + (v1.y - v2.y) * (v1.y - v2.y));
}

//------------------------------------------------------------------------------
static inline float UVector2LengthSqr(UVector2 v)
{
    return v.x * v.x + v.y * v.y;
}

//------------------------------------------------------------------------------
static inline float UVector2Direction(UVector2 v)
{
    return atan2f(v.y, v.x);
}

//------------------------------------------------------------------------------
static inline float UVector2DistanceSqr(UVector2 v1, UVector2 v2)
{
    return (v1.x - v2.x) * (v1.x - v2.x) + (v1.y - v2.y) * (v1.y - v2.y);
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
typedef struct _USize2d
{
    float   width;
    float   height;
} USize2d;

//------------------------------------------------------------------------------
static inline USize2d CGSizeToUSize2d(CGSize s);
static inline USize2d USize2dMake(float width, float height);
static inline CGSize USize2dToCGSize(USize2d s);
static inline BOOL USize2dEqualToUSize2d(USize2d s1, USize2d s2);

//------------------------------------------------------------------------------
static inline USize2d CGSizeToUSize2d(CGSize s)
{
    USize2d size = {.width = s.width, .height = s.height};

    return size;
}

//------------------------------------------------------------------------------
static inline USize2d USize2dMake(float width, float height)
{
    USize2d s = {.width = width, .height = height};

    return s;
}

//------------------------------------------------------------------------------
static inline CGSize USize2dToCGSize(USize2d s)
{
    return CGSizeMake(s.width, s.height);
}

//------------------------------------------------------------------------------
static inline BOOL USize2dEqualToUSize2d(USize2d s1, USize2d s2)
{
    return (s1.width == s2.width) && (s1.height == s2.height);
}

//------------------------------------------------------------------------------


