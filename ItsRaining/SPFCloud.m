//
//  SPFCloud.m
//  ItsRaining
//
//  Created by Simon Fry on 15/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFCloud.h"

@implementation SPFCloud

- (SPFCloud *)init
{
    self = [[SPFCloud alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    self.name = @"cloud";
    
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:0.0 duration:2.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100.0 y:0.0 duration:2.0]]];
    SKAction *cloudMovement = [SKAction repeatActionForever:hover];
    
    SKAction *rain = [SKAction sequence: @[
                                           [SKAction performSelector:@selector(makeRain) onTarget:self],
                                           [SKAction waitForDuration:0.10 withRange:0.15]]];
    SKAction *cloudRain = [SKAction repeatActionForever:rain];
    
    SKAction *cloudActions = [SKAction group:@[cloudMovement, cloudRain]];
    
    [self runAction:cloudActions];
    
    return self;
}

- (void)makeRain
{
    SKSpriteNode *rain = [[SKSpriteNode alloc] initWithColor:[SKColor lightGrayColor] size:CGSizeMake(8,8)];
    rain.position = CGPointMake(skRand(-1 * (self.size.width / 2), (self.size.width / 2)), -1 * (self.size.width / 2));
    rain.name = @"rain";
    rain.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rain.size];
    rain.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rain];
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@end
