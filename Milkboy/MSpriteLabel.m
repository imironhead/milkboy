//
//  MSpriteLabel.m
//  Milkboy
//
//  Created by iRonhead on 9/16/13.
//  Copyright (c) 2013 iRonhead. All rights reserved.
//
//------------------------------------------------------------------------------
#import "MSpriteLabel.h"


//------------------------------------------------------------------------------
@interface MSpriteLabel ()
@property (nonatomic, strong) NSDictionary* table;
@property (nonatomic, assign) float space;
@end

//------------------------------------------------------------------------------
@implementation MSpriteLabel
//------------------------------------------------------------------------------
+(id) labelWithTable:(NSDictionary*)table space:(float)space
{
    return [[MSpriteLabel alloc] initWithTable:table space:space text:nil];
}

//------------------------------------------------------------------------------
+(id) labelWithTable:(NSDictionary*)table space:(float)space text:(NSString*)text
{
    return [[MSpriteLabel alloc] initWithTable:table space:space text:text];
}

//------------------------------------------------------------------------------
-(id) initWithTable:(NSDictionary*)table space:(float)space text:(NSString*)text
{
    self = [super init];

    if (self)
    {
        NSAssert(table && table.count, @"[MSpriteLabel initWithTable: text:]");

        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:table[@"0"]];

        self.texture = frame.texture;

        self.space = space;

        NSMutableDictionary* t = [NSMutableDictionary dictionaryWithCapacity:table.count];

        self.table = t;

        for (id key in table)
        {
            t[key] = [NSString stringWithString:table[key]];
        }
    }

    return self;
}

//------------------------------------------------------------------------------
-(void) update
{
    NSString* text = self.text;

    NSUInteger len = (text ? text.length : 0);

    while (self.children.count > len)
    {
        [self removeChild:self.children.lastObject cleanup:FALSE];
    }

    while (self.children.count < len)
    {
        [self addChild:[CCSprite new]];
    }

    if (len)
    {
        NSUInteger i = 0;

        unichar c;

        float a = self.scale;

        float s = self.space;

        float x = 0.0f;

        NSString* k;

        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];

        for (CCSprite* sprite in self.children)
        {
            c = [text characterAtIndex:i];

            if (c == ' ')
            {
                sprite.displayFrame = [cache spriteFrameByName:self.table[@"0"]];

                sprite.scale = a;

                sprite.position = ccp(x, 0.0f);

                sprite.visible = FALSE;
            }
            else
            {
                k = [NSString stringWithCharacters:&c length:1];

                sprite.displayFrame = [cache spriteFrameByName:self.table[k]];

                sprite.scale = a;

                sprite.position = ccp(x, 0.0f);

                sprite.visible = TRUE;
            }

            x += (CGRectGetWidth(sprite.boundingBox) + s);

            i += 1;
        }
    }
}

//------------------------------------------------------------------------------
-(void) setText:(NSString*)text
{
    BOOL update = FALSE;

    if (text)
    {
        if (self->_text && [text isEqualToString:self->_text])
        {
        }
        else
        {
            self->_text = [NSString stringWithString:text];

            update = TRUE;
        }
    }
    else
    {
        if (self->_text)
        {
            self->_text = nil;

            update = TRUE;
        }
    }

    if (update)
    {
        [self update];
    }
}

//------------------------------------------------------------------------------
-(void) setScale:(float)scale
{
    if (self.scale != scale)
    {
        [super setScale:scale];

        [self update];
    }
}

//------------------------------------------------------------------------------
@end
