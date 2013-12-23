//
//  SPFPerson.m
//  ItsRaining
//
//  Created by Simon Fry on 23/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFPerson.h"
#import "SPFUtilities.h"

@implementation SPFPerson

@synthesize isWet;

- (SPFPerson *)init
{
    self = [[SPFPerson alloc] initWithColor:[SKColor darkGrayColor] size:CGSizeMake(8, 24)];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = personCategory;
    self.physicsBody.contactTestBitMask = rainCategory;
    self.physicsBody.collisionBitMask = floorCategory | rainCategory;
    
    SKAction *walk = [SKAction moveByX:-1200 y:0.0 duration:[SPFUtilities skRandWithLow:4 andHigh:12]];
    SKAction *finishWalking = [SKAction removeFromParent];
    SKAction *personMovement = [SKAction sequence:@[walk, finishWalking]];
    
    [self runAction:personMovement];
    
    isWet = NO;
    
    return self;
}

@end
