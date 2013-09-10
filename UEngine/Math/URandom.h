//
//  URandom.h
//  UEngineTestBed
//
//  Created by iRonhead on 3/26/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


//------------------------------------------------------------------------------
typedef struct _URandomIntegerRange
{
    uint32_t    min;
    uint32_t    max;
} URandomIntegerRange;

//------------------------------------------------------------------------------
static inline URandomIntegerRange URandomIntegerRangeMake(uint32_t min, uint32_t max);

//------------------------------------------------------------------------------
@protocol URandomIntegerGenerator <NSObject>
@property (nonatomic, assign, readonly) URandomIntegerRange range;
@property (nonatomic, assign, readonly) uint32_t randomInteger;
@end

//------------------------------------------------------------------------------
@protocol URandomFloatGenerator <NSObject>
@end

//------------------------------------------------------------------------------
@interface URandomIntegerGeneratorBase : NSObject<URandomIntegerGenerator>
@property (nonatomic, assign, readonly) URandomIntegerRange range;
@property (nonatomic, assign, readonly) uint32_t randomInteger;

+(id) randomIntegerGeneratorWithRange:(URandomIntegerRange)range;
+(id) randomIntegerGeneratorArc4randomUniformWithRange:(URandomIntegerRange)range;
+(id) randomIntegerGeneratorMWCWithRange:(URandomIntegerRange)range
                                   seedA:(uint32_t)seedA
                                   seedB:(uint32_t)seedB;
@end

//------------------------------------------------------------------------------
@interface URandomIntegerGeneratorArc4randomUniform : URandomIntegerGeneratorBase
+(id) randomIntegerGeneratorWithRange:(URandomIntegerRange)range;
@end

//------------------------------------------------------------------------------
//--MWC: multiply-with-carry by George Marsaglia
//------------------------------------------------------------------------------
@interface URandomIntegerGeneratorMWC : URandomIntegerGeneratorBase
+(id) randomIntegerGeneratorWithRange:(URandomIntegerRange)range
                                seedA:(uint32_t)seedA
                                seedB:(uint32_t)seedB;

-(id) initWithRange:(URandomIntegerRange)range
              seedA:(uint32_t)seedA
              seedB:(uint32_t)seedB;
@end

//------------------------------------------------------------------------------
@interface UAverageRandomIntegerGeneratorMWC : URandomIntegerGeneratorMWC
+(id) averageRandomIntegerGeneratorWithRange:(URandomIntegerRange)range
                                       seedA:(uint32_t)seedA
                                       seedB:(uint32_t)seedB;

-(id) initWithRange:(URandomIntegerRange)range
              seedA:(uint32_t)seedA
              seedB:(uint32_t)seedB;
-(void) reset;
@end

//------------------------------------------------------------------------------
@interface URandomFloatGeneratorBase : NSObject<URandomFloatGenerator>
@end

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementations
#pragma mark -

//------------------------------------------------------------------------------
static inline URandomIntegerRange URandomIntegerRangeMake(uint32_t min, uint32_t max)
{
    URandomIntegerRange r = {.min = min, .max = max,};

    return r;
}

