//
//  URect.h
//  UEngineTestBed
//
//  Created by iRonhead on 2/20/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "ULine.h"
#import "UVector2.h"


//------------------------------------------------------------------------------
typedef struct _URect
{
    float   left;
    float   bottom;
    float   right;
    float   top;
} URect, UPadding;

//------------------------------------------------------------------------------
typedef enum _URectEdge
{
    URectEdgeLeft = 0,
    URectEdgeBottom,
    URectEdgeRight,
    URectEdgeTop,
    URectEdgeInvalid,
} URectEdge;

//------------------------------------------------------------------------------
static inline URect URectMake(float left, float bottom, float right, float top);
static inline URect URectTranslate(URect rect, UVector2 v);
static inline URect URectExpand(URect rect, float width);
static inline URect URectExpandSize(URect rect, USize2d size);
static inline URect URectUnion(URect r1, URect r2);
static inline URect URectLerp(URect r1, URect r2, float ratio);
static inline float URectWidth(URect rect);
static inline float URectHeight(URect rect);
static inline UVector2 URectCenter(URect rect);
static inline BOOL URectEqualToURect(URect r, URect s);
static inline BOOL URectCollideURect(URect r, URect s);
static inline BOOL URectContainsUVector2(URect r, UVector2 v);
static inline ULineSegment2d URectEdgeSegmentLeft(URect r);
static inline ULineSegment2d URectEdgeSegmentBottom(URect r);
static inline ULineSegment2d URectEdgeSegmentRight(URect r);
static inline ULineSegment2d URectEdgeSegmentTop(URect r);

extern ULineSegment2d URectEdgeSegment(URect r, URectEdge e);

//------------------------------------------------------------------------------
static inline URect URectMake(float left, float bottom, float right, float top)
{
    URect r = {.left = left, .bottom = bottom, .right = right, .top = top};

    return r;
}

//------------------------------------------------------------------------------
static inline URect URectTranslate(URect rect, UVector2 v)
{
    rect.left   += v.x;
    rect.right  += v.x;
    rect.bottom += v.y;
    rect.top    += v.y;

    return rect;
}

//------------------------------------------------------------------------------
static inline URect URectExpand(URect rect, float width)
{
    rect.left   -= width;
    rect.right  += width;
    rect.bottom -= width;
    rect.top    += width;

    return rect;
}

//------------------------------------------------------------------------------
static inline URect URectExpandSize(URect rect, USize2d size)
{
    rect.left   -= size.width;
    rect.right  += size.width;
    rect.bottom -= size.height;
    rect.top    += size.height;

    return rect;
}

//------------------------------------------------------------------------------
static inline URect URectUnion(URect r1, URect r2)
{
    r1.left   = MIN(r1.left, r2.left);
    r1.right  = MAX(r1.right, r2.right);
    r1.bottom = MIN(r1.bottom, r2.bottom);
    r1.top    = MAX(r1.top, r2.top);

    return r1;
}

//------------------------------------------------------------------------------
static inline URect URectLerp(URect r1, URect r2, float ratio)
{
    r1.left   += ratio * (r2.left   - r1.left);
    r1.bottom += ratio * (r2.bottom - r1.bottom);
    r1.right  += ratio * (r2.right  - r1.right);
    r1.top    += ratio * (r2.top    - r1.top);

    return r1;
}

//------------------------------------------------------------------------------
static inline float URectWidth(URect rect)
{
    return rect.right - rect.left;
}

//------------------------------------------------------------------------------
static inline float URectHeight(URect rect)
{
    return rect.top - rect.bottom;
}

//------------------------------------------------------------------------------
static inline UVector2 URectCenter(URect rect)
{
    UVector2 v = {.x = 0.5f * (rect.left + rect.right), .y = 0.5f * (rect.bottom + rect.top)};

    return v;
}

//------------------------------------------------------------------------------
static inline BOOL URectEqualToURect(URect r, URect s)
{
    return
        (r.left   == s.left) &&
        (r.bottom == s.bottom) &&
        (r.right  == s.right) &&
        (r.top    == s.top);
}

//------------------------------------------------------------------------------
static inline BOOL URectCollideURect(URect r, URect s)
{
    return
        (r.left < s.right) &&
        (r.right > s.left) &&
        (r.bottom < s.top) &&
        (r.top > s.bottom);
}

//------------------------------------------------------------------------------
static inline BOOL URectContainsUVector2(URect r, UVector2 v)
{
    return
        (r.left < v.x) &&
        (r.right > v.x) &&
        (r.bottom < v.y) &&
        (r.top > v.y);
}

//------------------------------------------------------------------------------
static inline ULineSegment2d URectEdgeSegmentLeft(URect r)
{
    ULineSegment2d s = {.b.x = r.left, .b.y = r.top, .e.x = r.left, .e.y = r.bottom};

    return s;
}

//------------------------------------------------------------------------------
static inline ULineSegment2d URectEdgeSegmentBottom(URect r)
{
    ULineSegment2d s = {.b.x = r.left, .b.y = r.bottom, .e.x = r.right, .e.y = r.bottom};

    return s;
}

//------------------------------------------------------------------------------
static inline ULineSegment2d URectEdgeSegmentRight(URect r)
{
    ULineSegment2d s = {.b.x = r.right, .b.y = r.top, .e.x = r.right, .e.y = r.bottom};

    return s;
}

//------------------------------------------------------------------------------
static inline ULineSegment2d URectEdgeSegmentTop(URect r)
{
    ULineSegment2d s = {.b.x = r.left, .b.y = r.top, .e.x = r.right, .e.y = r.top};

    return s;
}

//------------------------------------------------------------------------------
