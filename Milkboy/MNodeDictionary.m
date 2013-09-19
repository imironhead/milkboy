//
//  MNodeDictionary.m
//  Milkboy
//
//  Created by iRonhead on 9/18/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MNodeDictionary.h"


//------------------------------------------------------------------------------
@implementation MNodeDictionary
//------------------------------------------------------------------------------
+(id) nodeWithTag:(NSInteger)tag info:(NSDictionary*)info
{
    return [[self alloc] initWithTag:tag info:info];
}

//------------------------------------------------------------------------------
-(id) initWithTag:(NSInteger)tag info:(NSDictionary*)info
{
    self = [super init];

    if (self)
    {
        self.tag = tag;

        self->_info = info;
    }

    return self;
}

//------------------------------------------------------------------------------
@end
