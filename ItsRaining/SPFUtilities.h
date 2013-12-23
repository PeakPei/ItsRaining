//
//  SPFUtilities.h
//  ItsRaining
//
//  Created by Simon Fry on 15/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPFUtilities : NSObject

extern uint32_t const floorCategory;
extern uint32_t const rainCategory;
extern uint32_t const umbrellaCategory;
extern uint32_t const personCategory;


+ (CGFloat)skRandf;
+ (CGFloat)skRandWithLow:(CGFloat)low andHigh:(CGFloat)high;

@end
