//
//  UMathTypes.h
//  UEngineTestBed
//
//  Created by iRonhead on 4/2/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
typedef enum _UMatrixOperator
{
    UMatrixOperatorLocal,
    UMatrixOperatorGlobal,
    UMatrixOperatorReplace,
} UMatrixOperator;

//------------------------------------------------------------------------------
typedef struct _UTransform2dAffine
{
    float   m00,    m01;
    float   m10,    m11;
    float   m20,    m21;
} UTransform2dAffine;

//------------------------------------------------------------------------------
union _UMatrix2
{
    struct
    {
        float m00, m01;
        float m10, m11;
    };
    float m2[2][2];
    float m[4];
};

typedef union _UMatrix2 UMatrix2;

//------------------------------------------------------------------------------
union _UMatrix3
{
    struct
    {
        float m00, m01, m02;
        float m10, m11, m12;
        float m20, m21, m22;
    };
    float m[9];
};

typedef union _UMatrix3 UMatrix3;

//------------------------------------------------------------------------------
union _UMatrix4
{
    struct
    {
        float m00, m01, m02, m03;
        float m10, m11, m12, m13;
        float m20, m21, m22, m23;
        float m30, m31, m32, m33;
    };
    float m[16];
} __attribute__((aligned(16)));

typedef union _UMatrix4 UMatrix4;

//------------------------------------------------------------------------------
union _UVector2
{
    struct { float x, y; };
    struct { float s, t; };
    float v[2];
} __attribute__((aligned(8)));

typedef union _UVector2 UVector2;

//------------------------------------------------------------------------------
union _UVector3
{
    struct { float x, y, z; };
    struct { float r, g, b; };
    struct { float s, t, p; };
    float v[3];
};
typedef union _UVector3 UVector3;

//------------------------------------------------------------------------------
union _UVector4
{
    struct { float x, y, z, w; };
    struct { float r, g, b, a; };
    struct { float s, t, p, q; };
    float v[4];
} __attribute__((aligned(16)));

typedef union _UVector4 UVector4;

//------------------------------------------------------------------------------
union _UQuaternion
{
    struct { UVector3 v; float s; };
    struct { float x, y, z, w; };
    float q[4];
} __attribute__((aligned(16)));

typedef union _UQuaternion UQuaternion;

//------------------------------------------------------------------------------
