//
//  UTween.h
//  UEngineTestBed
//
//  Created by iRonhead on 3/21/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "../Render/UColor.h"
#import "URect.h"
#import "UVector2.h"
#import "UVector3.h"


//------------------------------------------------------------------------------
typedef enum _UTweenType
{
    UTweenTypeLinear,
    UTweenTypeEaseInQuad,
    UTweenTypeEaseOutQuad,
    UTweenTypeEaseInOutQuad,
    UTweenTypeEaseOutBack,
} UTweenType;

//------------------------------------------------------------------------------
@interface UTween : NSObject
@property (nonatomic, assign) UTweenType type;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) float elapsed;

+(id) tweenWithType:(UTweenType)type
           duration:(NSTimeInterval)duration;

-(float)        interpolateFloatSource:(float)source target:(float)target;
-(UColor4b)     interpolateUColor4bSource:(UColor4b)source target:(UColor4b)target;
-(URect)        interpolateURect:(URect)source target:(URect)target;
-(UVector2)     interpolateUVector2:(UVector2)source target:(UVector2)target;
@end
