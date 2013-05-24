//
//  UVector3.h
//  UEngineTestBed
//
//  Created by iRonhead on 4/2/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UMathTypes.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
static inline UVector3 UVector3Add(UVector3 v1, UVector3 v2);
static inline UVector3 UVector3Sub(UVector3 v1, UVector3 v2);
static inline UVector3 UVector3Make(float x, float y, float z);
static inline UVector3 UVector3Lerp(UVector3 v1, UVector3 v2, float f);
static inline UVector3 UVector3Scale(UVector3 v, float k);
static inline UVector3 UVector3Center(UVector3 v1, UVector3 v2);
static inline UVector3 UVector3Offset(UVector3 v, float x, float y, float z);
static inline UVector3 UVector3Normalize(UVector3 v);
static inline UVector3 UVector3MultiplyMatrix3(UVector3 vectorLeft, UMatrix3 matrixRight);

static inline BOOL UVector3EqualToUVector3(UVector3 v1, UVector3 v2);

static inline float UVector3Dot(UVector3 v1, UVector3 v2);
static inline float UVector3Length(UVector3 v);
static inline float UVector3Distance(UVector3 v1, UVector3 v2);
static inline float UVector3LengthSqr(UVector3 v);
static inline float UVector3DistanceSqr(UVector3 v1, UVector3 v2);

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
static inline UVector3 UVector3Add(UVector3 v1, UVector3 v2)
{
    v1.x += v2.x;
    v1.y += v2.y;
    v1.z += v2.z;

    return v1;
}

//------------------------------------------------------------------------------
inline UVector3 UVector3Make(float x, float y, float z)
{
    UVector3 v = {.x = x, .y = y, .z = z,};

    return v;
}

//------------------------------------------------------------------------------
static inline UVector3 UVector3Scale(UVector3 v, float k)
{
    v.x *= k;
    v.x *= k;
    v.x *= k;

    return v;
}

//------------------------------------------------------------------------------
static inline UVector3 UVector3Normalize(UVector3 v)
{
    float s = 1.0f / sqrtf(v.x * v.x + v.y * v.y + v.z * v.z);

    v.x *= s;
    v.y *= s;
    v.z *= s;

    return v;
}

//------------------------------------------------------------------------------
static inline UVector3 UVector3MultiplyMatrix3(UVector3 vectorLeft, UMatrix3 matrixRight)
{
    UVector3 v =
    {
        vectorLeft.x * matrixRight.m00 + vectorLeft.y * matrixRight.m10 + vectorLeft.z * matrixRight.m20,
        vectorLeft.x * matrixRight.m01 + vectorLeft.y * matrixRight.m11 + vectorLeft.z * matrixRight.m21,
        vectorLeft.x * matrixRight.m02 + vectorLeft.y * matrixRight.m12 + vectorLeft.z * matrixRight.m22,
    };

    return v;
}

