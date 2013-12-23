//
//  SPFCloud.m
//  ItsRaining
//
//  Created by Simon Fry on 15/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFCloud.h"
#import "SPFUtilities.h"

@implementation SPFCloud

static const uint32_t floorCategory = 0x1 << 0;
static const uint32_t rainCategory = 0x1 << 1;
static const uint32_t umbrellaCategory = 0x1 << 2;
static const uint32_t personCategory = 0x1 << 3;

- (SPFCloud *)init
{
    self = [[SPFCloud alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    self.name = @"cloud";
    
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction moveByX:1200 y:0.0 duration:[SPFUtilities skRandWithLow:4 andHigh:12]]]];
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
    rain.position = CGPointMake([SPFUtilities skRandWithLow:-1 * (self.size.width / 2) andHigh:(self.size.width / 2)], -1 * (self.size.width / 2));
    rain.name = @"rain";
    rain.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rain.size];
    rain.physicsBody.usesPreciseCollisionDetection = YES;
    rain.physicsBody.categoryBitMask = rainCategory;
    rain.physicsBody.collisionBitMask = floorCategory | umbrellaCategory | personCategory;
    rain.physicsBody.contactTestBitMask = floorCategory | umbrellaCategory | personCategory;
    [self addChild:rain];
}



@end
