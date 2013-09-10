//
//  URandom.m
//  UEngineTestBed
//
//  Created by iRonhead on 3/26/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "URandom.h"


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface URandomIntegerGeneratorBase()
@property (nonatomic, readwrite, assign) URandomIntegerRange range;
@property (nonatomic, assign) uint32_t min;
@property (nonatomic, assign) uint32_t factor;
@end

//------------------------------------------------------------------------------
@implementation URandomIntegerGeneratorBase
//------------------------------------------------------------------------------
+(id) randomIntegerGeneratorWithRange:(URandomIntegerRange)range
{
    return [[URandomIntegerGeneratorBase alloc] initWithRange:range];
}

//------------------------------------------------------------------------------
+(id) randomIntegerGeneratorArc4randomUniformWithRange:(URandomIntegerRange)range
{
    return [[URandomIntegerGeneratorArc4randomUniform alloc] initWithRange:range];
}

//------------------------------------------------------------------------------
+(id) randomIntegerGeneratorMWCWithRange:(URandomIntegerRange)range
                                   seedA:(uint32_t)seedA
                                   seedB:(uint32_t)seedB
{
    return [[URandomIntegerGeneratorMWC alloc] initWithRange:range seedA:seedA seedB:seedB];
}

//------------------------------------------------------------------------------
-(id) initWithRange:(URandomIntegerRange)range
{
    self = [super init];

    if (self)
    {
        NSAssert(range.max > range.min, @"[URandomIntegerGeneratorBase initWithRange:]");

        self.min    = range.min;
        self.factor = range.max - range.min + 1;
    }

    return self;
}

//------------------------------------------------------------------------------
-(uint32_t) randomInteger
{
    return self.min + arc4random() % self.factor;
}

//------------------------------------------------------------------------------
-(void) setRange:(URandomIntegerRange)range
{
    NSAssert(range.max > range.min, @"[URandomIntegerGeneratorBase setRange:]");

    self.min    = range.min;
    self.factor = range.max - range.min + 1;
}

//------------------------------------------------------------------------------
-(URandomIntegerRange) range
{
    URandomIntegerRange r = {.min = self.min, .max = self.factor + self.min - 1};

    return r;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface URandomIntegerGeneratorArc4randomUniform()
@property (nonatomic, assign) uint32_t min;
@property (nonatomic, assign) uint32_t factor;
@end

//------------------------------------------------------------------------------
@implementation URandomIntegerGeneratorArc4randomUniform
//------------------------------------------------------------------------------
+(id) randomIntegerGeneratorWithRange:(URandomIntegerRange)range
{
    return [[URandomIntegerGeneratorArc4randomUniform alloc] initWithRange:range];
}

//------------------------------------------------------------------------------
-(id) initWithRange:(URandomIntegerRange)range
{
    self = [super initWithRange:range];

    return self;
}

//------------------------------------------------------------------------------
-(uint32_t) randomInteger
{
    return self.min + arc4random_uniform(self.factor);
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface URandomIntegerGeneratorMWC()
@property (nonatomic, assign) uint32_t seedA;
@property (nonatomic, assign) uint32_t seedB;
@end

//------------------------------------------------------------------------------
@implementation URandomIntegerGeneratorMWC
//------------------------------------------------------------------------------
+(id) randomIntegerGeneratorWithRange:(URandomIntegerRange)range
                                seedA:(uint32_t)seedA
                                seedB:(uint32_t)seedB
{
    return [[URandomIntegerGeneratorMWC alloc] initWithRange:range seedA:seedA seedB:seedB];
}

//------------------------------------------------------------------------------
-(id) initWithRange:(URandomIntegerRange)range
              seedA:(uint32_t)seedA
              seedB:(uint32_t)seedB
{
    self = [super initWithRange:range];

    if (self)
    {
        NSAssert(seedA || seedB, @"[URandomIntegerGeneratorMWC initWithRange: seedA: seedB:]");

        self.seedA = seedA;
        self.seedB = seedB;
    }

    return self;
}

//------------------------------------------------------------------------------
-(uint32_t) randomInteger
{
    self->_seedA = 36969 * (self->_seedA & 65535) + (self->_seedA >> 16);
    self->_seedB = 18000 * (self->_seedB & 65535) + (self->_seedB >> 16);

    return self.min + ((self->_seedA << 16) + self->_seedB) % self.factor;
}

//------------------------------------------------------------------------------
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface UAverageRandomIntegerGeneratorMWC()
@property (nonatomic, strong) NSMutableData* buffer;
@property (nonatomic, assign) int32_t count;
@property (nonatomic, assign) int32_t index;
@property (nonatomic, assign) uint32_t previous;
@end

//------------------------------------------------------------------------------
@implementation UAverageRandomIntegerGeneratorMWC
//------------------------------------------------------------------------------
+(id) averageRandomIntegerGeneratorWithRange:(URandomIntegerRange)range
                                       seedA:(uint32_t)seedA
                                       seedB:(uint32_t)seedB
{
    return [[UAverageRandomIntegerGeneratorMWC alloc] initWithRange:range seedA:seedA seedB:seedB];
}

//------------------------------------------------------------------------------
-(id) initWithRange:(URandomIntegerRange)range
              seedA:(uint32_t)seedA
              seedB:(uint32_t)seedB
{
    self = [super initWithRange:range seedA:seedA seedB:seedB];

    if (self)
    {
        self.count = range.max - range.min + 1;
        self.index = -1;
        self.previous = 0;

        self.buffer = [NSMutableData dataWithLength:self.count * sizeof(uint32_t)];
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) reset
{
    self.index = -1;
    self.previous = 0;
}

//------------------------------------------------------------------------------
-(uint32_t) randomInteger
{
    bool r = false;

    if (self.index < 0)
    {
        self.index = self.count - 1;

        uint32_t* t = self.buffer.mutableBytes;

        for (uint32_t i = self.range.min; i <= self.range.max; ++i, ++t)
        {
            *t = i;
        }

        r = true;
    }

    self.seedA = 36969 * (self.seedA & 65535) + (self.seedA >> 16);
    self.seedB = 18000 * (self.seedB & 65535) + (self.seedB >> 16);

    uint32_t k = ((self.seedA << 16) + self.seedB);

    uint32_t* t = self.buffer.mutableBytes;

    if (r)
    {
        NSAssert(self.index > 0, @"[UAverageRandomIntegerGeneratorMWC randomInteger]");

        k %= self.index;

        if (k >= self.previous)
        {
            k += 1;
        }
    }
    else
    {
        k %= (self.index + 1);
    }

    uint32_t z = t[k];

    t[k] = t[self.index];

    self.index -= 1;

    self.previous = z;

    return z;
}

//------------------------------------------------------------------------------
@end

