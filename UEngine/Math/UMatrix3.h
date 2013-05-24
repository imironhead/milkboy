//
//  UMatrix3.h
//  UEngineTestBed
//
//  Created by iRonhead on 4/3/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UMathTypes.h"
#import "UQuaternion.h"
#import "UVector3.h"


//------------------------------------------------------------------------------
#ifdef __ARM_NEON__
#include <arm_neon.h>
#endif

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark -
#pragma mark UMatrix3 prototypes
#pragma mark -

//------------------------------------------------------------------------------
static inline UVector3 UMatrix3MultiplyVector3(UMatrix3 matrixLeft, UVector3 vectorRight);


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark -
#pragma mark UMatrix3 implementations
#pragma mark -

//------------------------------------------------------------------------------
static inline UVector3 UMatrix3MultiplyVector3(UMatrix3 matrixLeft, UVector3 vectorRight)
{
    UVector3 v =
    {
        matrixLeft.m[0] * vectorRight.v[0] + matrixLeft.m[1] * vectorRight.v[1] + matrixLeft.m[2] * vectorRight.v[2],
        matrixLeft.m[3] * vectorRight.v[0] + matrixLeft.m[4] * vectorRight.v[1] + matrixLeft.m[5] * vectorRight.v[2],
        matrixLeft.m[6] * vectorRight.v[0] + matrixLeft.m[7] * vectorRight.v[1] + matrixLeft.m[8] * vectorRight.v[2],
    };

    return v;
}
