//
//  UTween.m
//  UEngineTestBed
//
//  Created by iRonhead on 3/21/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "UTween.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface UTween()
@property (nonatomic, assign) float factor;
@end

//------------------------------------------------------------------------------
@implementation UTween
//------------------------------------------------------------------------------
+(id) tweenWithType:(UTweenType)type
           duration:(NSTimeInterval)duration
{
    UTween* tween = [UTween new];

    tween->_type     = type;
    tween->_duration = duration;
    tween->_elapsed  = 0.0f;

    [tween updateFactor];

    return tween;
}

//------------------------------------------------------------------------------
-(void) setType:(UTweenType)type
{
    self->_type = type;

    [self updateFactor];
}

//------------------------------------------------------------------------------
-(void) setDuration:(NSTimeInterval)duration
{
    self->_duration = duration;

    [self updateFactor];
}

//------------------------------------------------------------------------------
-(void) setElapsed:(float)elapsed
{
    self->_elapsed = elapsed;

    [self updateFactor];
}

//------------------------------------------------------------------------------
-(void) updateFactor
{
    switch (self.type)
    {
    case UTweenTypeLinear:
        {
            self.factor = self->_elapsed / self->_duration;
        }
        break;
    case UTweenTypeEaseInQuad:
        {
            float k = self->_elapsed / self.duration;

            self.factor = k * k;
        }
        break;
    case UTweenTypeEaseOutQuad:
        {
            float k = self->_elapsed / self.duration;

            self.factor = k * (2.0f - k);
        }
        break;
    case UTweenTypeEaseInOutQuad:
        {
            float k = self->_elapsed / self.duration;

            if (k <= 0.5f)
            {
                self.factor = 2.0f * k * k;
            }
            else
            {
                self.factor = -2.0f * ((k - 0.5f) * (k - 1.5f) - 0.25f);
            }
        }
        break;
    case UTweenTypeEaseOutBack:
        {
            float s = 1.70158f;
            float k = self->_elapsed / self.duration - 1.0f;


            self.factor = (k * k * (k * (s + 1) + s) + 1.0f);
        }
        break;
    }
}

//------------------------------------------------------------------------------
-(float) interpolateFloatSource:(float)source target:(float)target
{
    return source + self.factor * (target - source);
}

//------------------------------------------------------------------------------
-(UColor4b) interpolateUColor4bSource:(UColor4b)source target:(UColor4b)target
{
    UColor4b c = 0x00000000;

    float f = self.factor;
    float s;
    float t;

    s = (float)(source >> 24);
    t = (float)(target >> 24);

    s += f * (t - s);

    c |= ((((uint32_t)s) & 0xff) << 24);

    s = (float)((source & 0x00ff0000) >> 16);
    t = (float)((target & 0x00ff0000) >> 16);

    s += f * (t - s);

    c |= ((((uint32_t)s) & 0xff) << 16);

    s = (float)((source & 0x0000ff00) >> 8);
    t = (float)((target & 0x0000ff00) >> 8);

    s += f * (t - s);

    c |= ((((uint32_t)s) & 0xff) << 8);

    s = (float)((source & 0x000000ff));
    t = (float)((target & 0x000000ff));

    s += f * (t - s);

    c |= ((((uint32_t)s) & 0xff));

    return c;
}

//------------------------------------------------------------------------------
-(URect) interpolateURect:(URect)source target:(URect)target
{
    float f = self.factor;

    source.left   += f * (target.left   - source.left);
    source.bottom += f * (target.bottom - source.bottom);
    source.right  += f * (target.right  - source.right);
    source.top    += f * (target.top    - source.top);

    return source;
}

//------------------------------------------------------------------------------
-(UVector2) interpolateUVector2:(UVector2)source target:(UVector2)target
{
    source.x += self.factor * (target.x - source.x);
    source.y += self.factor * (target.y - source.y);

    return source;
}

//------------------------------------------------------------------------------
@end
