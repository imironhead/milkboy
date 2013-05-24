//
//  UTransform2dAffine.h
//  UEngineTestBed
//
//  Created by iRonhead on 2/22/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UTransform2dAffine.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark -
#pragma mark UTransform2dAffine
#pragma mark -

//------------------------------------------------------------------------------
UTransform2dAffine UTransform2dAffineRotateLocal(UTransform2dAffine m, float angle)
{
    float c = cosf(angle);
    float s = sinf(angle);

    UTransform2dAffine x =
    {
        s * m.m10 + c * m.m00,
        s * m.m11 + c * m.m01,
        c * m.m10 - s * m.m00,
        c * m.m11 - s * m.m01,
        m.m20,
        m.m21,
    };

    return x;
}

//------------------------------------------------------------------------------
UTransform2dAffine UTransform2dAffineRotateGlobal(UTransform2dAffine m, float angle)
{
    float c = cosf(angle);
    float s = sinf(angle);

    UTransform2dAffine x =
    {
        m.m00 * c - m.m01 * s,
        m.m00 * s + m.m01 * c,
        m.m10 * c - m.m11 * s,
        m.m10 * s + m.m11 * c,
        m.m20 * c - m.m21 * s,
        m.m20 * s + m.m21 * c,
    };

    return x;
}

//------------------------------------------------------------------------------
UTransform2dAffine UTransform2dAffineInvert(UTransform2dAffine m)
{
    UTransform2dAffine x;

    if (m.m00 * m.m11 == m.m10 * m.m01)
    {
        x = m;
    }
    else
    {
        //--!!!
        x.m20 = - m.m00 * m.m20 - m.m01 * m.m21;
        x.m21 = - m.m10 * m.m20 - m.m11 * m.m21;
        x.m00 = m.m00;
        x.m01 = m.m10;
        x.m10 = m.m01;
        x.m11 = m.m11;
    }

    return x;
}

//------------------------------------------------------------------------------
UTransform2dAffine UTransform2dAffineConcat(UTransform2dAffine m1, UTransform2dAffine m2)
{
    UTransform2dAffine x;

    x.m00 = m1.m00 * m2.m00 + m1.m01 * m2.m10;
    x.m01 = m1.m00 * m2.m01 + m1.m01 * m2.m11;
    x.m10 = m1.m10 * m2.m00 + m1.m11 * m2.m10;
    x.m11 = m1.m10 * m2.m01 + m1.m11 * m2.m11;
    x.m20 = m1.m20 * m2.m00 + m1.m21 * m2.m10 + m2.m20;
    x.m21 = m1.m20 * m2.m01 + m1.m21 * m2.m11 + m2.m21;

    return x;
}

