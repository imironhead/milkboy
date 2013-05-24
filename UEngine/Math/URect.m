//
//  URect.m
//  UEngineTestBed
//
//  Created by iRonhead on 2/20/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UMathConstant.h"
#import "URect.h"


//------------------------------------------------------------------------------
ULineSegment2d URectEdgeSegment(URect r, URectEdge e)
{
    ULineSegment2d s;

    switch (e)
    {
    case URectEdgeLeft:
        {
            s.b.x = r.left;
            s.e.x = r.left;
            s.b.y = r.top;
            s.e.y = r.bottom;
        }
        break;
    case URectEdgeBottom:
        {
            s.b.x = r.left;
            s.e.x = r.right;
            s.b.y = r.bottom;
            s.e.y = r.bottom;
        }
        break;
    case URectEdgeRight:
        {
            s.b.x = r.right;
            s.e.x = r.right;
            s.b.y = r.top;
            s.e.y = r.bottom;
        }
        break;
    case URectEdgeTop:
        {
            s.b.x = r.left;
            s.e.x = r.right;
            s.b.y = r.top;
            s.e.y = r.top;
        }
        break;
    default:
        {
            s.b = UVector2Infinity;
            s.e = UVector2Infinity;
        }
        break;
    }

    return s;
}


