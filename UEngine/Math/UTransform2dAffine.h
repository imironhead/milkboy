//
//  UTransform2dAffine.h
//  UEngineTestBed
//
//  Created by iRonhead on 2/22/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UMathTypes.h"


//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineMake(float _00, float _01, float _10, float _11, float _20, float _21);
static inline UTransform2dAffine UTransform2dAffineMakeTranslation(float dx, float dy);
static inline UTransform2dAffine UTransform2dAffineMakeScale(float sx, float sy);
static inline UTransform2dAffine UTransform2dAffineMakeRotation(float angle);
static inline UTransform2dAffine UTransform2dAffineTranslateLocal(UTransform2dAffine m, float tx, float ty);
static inline UTransform2dAffine UTransform2dAffineTranslateGlobal(UTransform2dAffine m, float tx, float ty);
static inline UTransform2dAffine UTransform2dAffineScaleLocal(UTransform2dAffine m, float sx, float sy);
static inline UTransform2dAffine UTransform2dAffineScaleGlobal(UTransform2dAffine m, float sx, float sy);
static inline UVector2 UTransform2dAffineGetAxisX(UTransform2dAffine m);
static inline UVector2 UTransform2dAffineGetAxisY(UTransform2dAffine m);
static inline UVector2 UVector2ApplyUTransform2dAffine(UVector2 v, UTransform2dAffine m);

static inline BOOL UTransform2dAffineIsIdentity(UTransform2dAffine m);
static inline BOOL UTransform2dAffineEqualToUTransform2dAffine(UTransform2dAffine m1, UTransform2dAffine m2);

extern UTransform2dAffine UTransform2dAffineRotateLocal(UTransform2dAffine m, float angle);
extern UTransform2dAffine UTransform2dAffineRotateGlobal(UTransform2dAffine m, float angle);
extern UTransform2dAffine UTransform2dAffineInvert(UTransform2dAffine m);
extern UTransform2dAffine UTransform2dAffineConcat(UTransform2dAffine m1, UTransform2dAffine m2);

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineMake(
    float _00,
    float _01,
    float _10,
    float _11,
    float _20,
    float _21)
{
    UTransform2dAffine m = {_00, _01, _10, _11, _20, _21};

    return m;
}

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineMakeTranslation(float dx, float dy)
{
    UTransform2dAffine m = {1.0f, 0.0f, 0.0f, 1.0f, dx, dy};

    return m;
}

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineMakeScale(float sx, float sy)
{
    UTransform2dAffine m = {sx, 0.0f, 0.0f, sy, 0.0f, 0.0f};

    return m;
}

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineMakeRotation(float angle)
{
    float c = cosf(angle);
    float s = sinf(angle);

    UTransform2dAffine m =
    {
        c, s,
        -s, c,
        0.0f, 0.0f,
    };

    return m;
}

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineTranslateLocal(UTransform2dAffine m, float tx, float ty)
{
    m.m20 += tx * m.m00 + ty * m.m10;
    m.m21 += tx * m.m01 + ty * m.m11;

    return m;
}

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineTranslateGlobal(UTransform2dAffine m, float tx, float ty)
{
    m.m20 += tx;
    m.m21 += ty;

    return m;
}

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineScaleLocal(UTransform2dAffine m, float sx, float sy)
{
    m.m00 *= sx;
    m.m01 *= sx;
    m.m10 *= sy;
    m.m11 *= sy;

    return m;
}

//------------------------------------------------------------------------------
static inline UTransform2dAffine UTransform2dAffineScaleGlobal(UTransform2dAffine m, float sx, float sy)
{
    m.m00 *= sx;
    m.m01 *= sy;
    m.m10 *= sx;
    m.m11 *= sy;
    m.m20 *= sx;
    m.m21 *= sy;

    return m;
}

//------------------------------------------------------------------------------
static inline UVector2 UTransform2dAffineGetAxisX(UTransform2dAffine m)
{
    UVector2 v = {m.m00, m.m01};

    return v;
}

//------------------------------------------------------------------------------
static inline UVector2 UTransform2dAffineGetAxisY(UTransform2dAffine m)
{
    UVector2 v = {m.m10, m.m11};

    return v;
}

//------------------------------------------------------------------------------
static inline UVector2 UVector2ApplyUTransform2dAffine(UVector2 vs, UTransform2dAffine m)
{
    UVector2 vt =
    {
        vs.x * m.m00 + vs.y * m.m10 + m.m20,
        vs.x * m.m01 + vs.y * m.m11 + m.m21,
    };

    return vt;
}

//------------------------------------------------------------------------------
static inline BOOL UTransform2dAffineIsIdentity(UTransform2dAffine m)
{
    return
        (m.m00 == 1.0f) &&
        (m.m01 == 0.0f) &&
        (m.m10 == 0.0f) &&
        (m.m11 == 1.0f) &&
        (m.m20 == 0.0f) &&
        (m.m21 == 0.0f);
}

//------------------------------------------------------------------------------
static inline BOOL UTransform2dAffineEqualToUTransform2dAffine(UTransform2dAffine m1, UTransform2dAffine m2)
{
    return
        (m1.m00 == m2.m00) &&
        (m1.m01 == m2.m01) &&
        (m1.m10 == m2.m10) &&
        (m1.m11 == m2.m11) &&
        (m1.m20 == m2.m20) &&
        (m1.m21 == m2.m21);
}

