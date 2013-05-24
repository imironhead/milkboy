//
//  UIntersection2d.m
//  UEngineTestBed
//
//  Created by iRonhead on 3/25/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UIntersection2d.h"
#import "UMathConstant.h"


//------------------------------------------------------------------------------
UVector2 ULineSegment2dIntersectULineSegment2d(ULineSegment2d s, ULineSegment2d t)
{
    UVector2 r;

    UVector2 vs = UVector2Sub(s.e, s.b);

    if (t.b.x == t.e.x)
    {
        r.x = t.b.x;

        if (vs.x == 0.0f)
        {
            //--parallel
            r = UVector2Infinity;
        }
        else if (((s.b.x > r.x) && (s.e.x > r.x)) ||
                 ((s.b.x < r.x) && (s.e.x < r.x)))
        {
            r = UVector2Infinity;
        }
        else if (vs.y == 0.0f)
        {
            //--pi / 2
            r.y = s.b.y;

            if (((t.b.y > r.y) && (t.e.y > r.y)) ||
                ((t.b.y < r.y) && (t.e.y < r.y)))
            {
                r = UVector2Infinity;
            }
        }
        else if (s.b.x == t.b.x)
        {
            r.y = s.b.y;

            if (((t.b.y > r.y) && (t.e.y > r.y)) ||
                ((t.b.y < r.y) && (t.e.y < r.y)))
            {
                r = UVector2Infinity;
            }
            else
            {
                r.x = t.b.x;
            }
        }
        else if (s.e.x == t.b.x)
        {
            r.y = s.e.y;

            if (((t.b.y > r.y) && (t.e.y > r.y)) ||
                ((t.b.y < r.y) && (t.e.y < r.y)))
            {
                r = UVector2Infinity;
            }
            else
            {
                r.x = t.e.x;
            }
        }
        else
        {
            float k = (t.b.x - s.b.x) / vs.x;

            if ((k < 0.0f) || (k > 1.0f))
            {
                r = UVector2Infinity;
            }
            else
            {
                r.x = s.b.x + k * vs.x;
                r.y = s.b.y + k * vs.y;
            }
        }
    }
    else if (t.b.y == t.e.y)
    {
        r.y = t.b.y;

        if (vs.y == 0.0f)
        {
            //--parallel
            r = UVector2Infinity;
        }
        else if (((s.b.y > r.y) && (s.e.y > r.y)) ||
                 ((s.b.y < r.y) && (s.e.y < r.y)))
        {
            r = UVector2Infinity;
        }
        else if (vs.x == 0.0f)
        {
            //--pi / 2
            r.x = s.b.x;

            if (((t.b.x > r.x) && (t.e.x > r.x)) ||
                ((t.b.x < r.x) && (t.e.x < r.x)))
            {
                r = UVector2Infinity;
            }
        }
        else if (s.b.y == t.b.y)
        {
            r.x = s.b.x;

            if (((t.b.x > r.x) && (t.e.x > r.x)) ||
                ((t.b.x < r.x) && (t.e.x < r.x)))
            {
                r = UVector2Infinity;
            }
            else
            {
                r.y = t.b.y;
            }
        }
        else if (s.e.y == t.b.y)
        {
            r.x = s.e.x;

            if (((t.b.x > r.x) && (t.e.x > r.x)) ||
                ((t.b.x < r.x) && (t.e.x < r.x)))
            {
                r = UVector2Infinity;
            }
            else
            {
                r.y = t.e.y;
            }
        }
        else
        {
            float k = (t.b.y - s.b.y) / vs.y;

            if ((k < 0.0f) || (k > 1.0f))
            {
                r = UVector2Infinity;
            }
            else
            {
                r.x = s.b.x + k * vs.x;
                r.y = s.b.y + k * vs.y;
            }
        }
    }
    else
    {
        //--not implemented

        r = UVector2Infinity;
    }

    return r;
}

