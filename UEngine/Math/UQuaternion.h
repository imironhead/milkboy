//
//  UQuaternion.h
//  UEngineTestBed
//
//  Created by iRonhead on 4/2/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UMathTypes.h"


//------------------------------------------------------------------------------
#ifdef __ARM_NEON__
#include <arm_neon.h>
#endif

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Prototypes
#pragma mark -

//------------------------------------------------------------------------------
static inline UQuaternion UQuaternionNormalize(UQuaternion quaternion);



//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Implementations
#pragma mark -

//------------------------------------------------------------------------------
static inline float UQuaternionLength(UQuaternion quaternion)
{
#if defined(__ARM_NEON__)

    float32x4_t v = vmulq_f32(*(float32x4_t*)&quaternion,
                              *(float32x4_t*)&quaternion);

    float32x2_t v2 = vpadd_f32(vget_low_f32(v), vget_high_f32(v));

    v2 = vpadd_f32(v2, v2);

    return sqrt(vget_lane_f32(v2, 0));

#else

    return sqrt(quaternion.q[0] * quaternion.q[0] +
                quaternion.q[1] * quaternion.q[1] +
                quaternion.q[2] * quaternion.q[2] +
                quaternion.q[3] * quaternion.q[3]);

#endif
}

//------------------------------------------------------------------------------
static inline UQuaternion UQuaternionNormalize(UQuaternion quaternion)
{
    float scale = 1.0f / UQuaternionLength(quaternion);

#if defined(__ARM_NEON__)
    float32x4_t v = vmulq_f32(*(float32x4_t*)&quaternion,
                              vdupq_n_f32((float32_t)scale));
    return *(UQuaternion *)&v;
#else
    UQuaternion q = { quaternion.q[0] * scale, quaternion.q[1] * scale, quaternion.q[2] * scale, quaternion.q[3] * scale };
    return q;
#endif
}

