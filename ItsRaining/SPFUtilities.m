//
//  SPFUtilities.m
//  ItsRaining
//
//  Created by Simon Fry on 15/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFUtilities.h"

@implementation SPFUtilities

+ (CGFloat)skRandf
{
    return rand() / (CGFloat) RAND_MAX;
}

+ (CGFloat)skRandWithLow:(CGFloat)low andHigh:(CGFloat)high
{
    return [self skRandf] * (high - low) + low;
}

@end
