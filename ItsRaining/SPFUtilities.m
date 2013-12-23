//
//  SPFUtilities.m
//  ItsRaining
//
//  Created by Simon Fry on 15/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFUtilities.h"

@implementation SPFUtilities

uint32_t const floorCategory = 0x1 << 0;
uint32_t const rainCategory = 0x1 << 1;
uint32_t const umbrellaCategory = 0x1 << 2;
uint32_t const personCategory = 0x1 << 3;

+ (CGFloat)skRandf
{
    return rand() / (CGFloat) RAND_MAX;
}

+ (CGFloat)skRandWithLow:(CGFloat)low andHigh:(CGFloat)high
{
    return [self skRandf] * (high - low) + low;
}

@end
