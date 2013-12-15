//
//  SPFCloud.m
//  ItsRaining
//
//  Created by Simon Fry on 15/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFCloud.h"

@implementation SPFCloud

+ (SPFCloud *)newCloud
{
    SPFCloud *cloud = [[SPFCloud alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    cloud.name = @"cloud";
    
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:0.0 duration:2.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100.0 y:0.0 duration:2.0]]];
    [cloud runAction: [SKAction repeatActionForever:hover]];
    
    return cloud;
}

@end
