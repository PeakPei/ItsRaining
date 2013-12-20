//
//  SPFSpaceshipScene.m
//  ItsRaining
//
//  Created by Simon Fry on 14/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFSpaceshipScene.h"
#import "SPFCloud.h"
#import "SPFUtilities.h"

@interface SPFSpaceshipScene ()

@property BOOL contentCreated;

@end

@implementation SPFSpaceshipScene

static const uint32_t floorCategory = 0x1 << 0;
static const uint32_t rainCategory = 0x1 << 1;
static const uint32_t umbrellaCategory = 0x1 << 2;

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.contactDelegate = self;
    
    [self addChild:[self newFloor]];
    
    SKSpriteNode *spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    [self addChild:spaceship];
    
    SKSpriteNode *umbrella = [self newUmbrella];
    umbrella.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 300);
    [self addChild:umbrella];
    
    SKAction *makeItRain = [SKAction sequence: @[
                                                 [SKAction performSelector:@selector(addCloud) onTarget:self],
                                                 [SKAction waitForDuration:2 withRange:1]]];
    SKAction *makeItAlwaysRain = [SKAction repeatActionForever:makeItRain];
    [self runAction:makeItAlwaysRain];
}

- (SKSpriteNode *)newSpaceship
{
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64,32)];
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:50.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100.0 y:-50 duration:1.0]]];
    [hull runAction: [SKAction repeatActionForever:hover]];
    
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    return hull;
}

- (SKSpriteNode *)newUmbrella
{
    SKSpriteNode *umbrella = [[SKSpriteNode alloc] init];
    umbrella.size = CGSizeMake(64, 64);
    umbrella.name = @"umbrella";
    
    SKSpriteNode *umbrellaTop1 = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(32, 8)];
    umbrellaTop1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:umbrellaTop1.size];
    umbrellaTop1.physicsBody.dynamic = NO;
    umbrellaTop1.physicsBody.categoryBitMask = umbrellaCategory;
    umbrellaTop1.physicsBody.contactTestBitMask = rainCategory;
    
    SKSpriteNode *umbrellaTop2 = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(48, 8)];
    umbrellaTop2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:umbrellaTop2.size];
    umbrellaTop2.physicsBody.dynamic = NO;
    umbrellaTop2.physicsBody.categoryBitMask = umbrellaCategory;
    umbrellaTop2.physicsBody.contactTestBitMask = rainCategory;
    
    SKSpriteNode *umbrellaTop3 = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 8)];
    umbrellaTop3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:umbrellaTop3.size];
    umbrellaTop3.physicsBody.dynamic = NO;
    umbrellaTop3.physicsBody.categoryBitMask = umbrellaCategory;
    umbrellaTop3.physicsBody.contactTestBitMask = rainCategory;
    
    SKSpriteNode *umbrellaHandle = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(8, 40)];
    umbrellaHandle.physicsBody.dynamic = NO;
    umbrellaHandle.physicsBody.categoryBitMask = umbrellaCategory;
    umbrellaHandle.physicsBody.contactTestBitMask = rainCategory;
    
    umbrellaTop1.position = CGPointMake(0, 28);
    umbrellaTop2.position = CGPointMake(0, 20);
    umbrellaTop3.position = CGPointMake(0, 12);
    umbrellaHandle.position = CGPointMake(0, -10);
    [umbrella addChild:umbrellaTop1];
    [umbrella addChild:umbrellaTop2];
    [umbrella addChild:umbrellaTop3];
    [umbrella addChild:umbrellaHandle];
    
    return umbrella;
}

- (SKSpriteNode *)newFloor
{
    SKSpriteNode *floor = [[SKSpriteNode alloc] initWithColor:[SKColor lightGrayColor] size:CGSizeMake(768, 8)];
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = floorCategory;
    floor.physicsBody.contactTestBitMask = rainCategory;
    floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -500.0);
    
    return floor;
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}

- (void)addCloud
{
    SPFCloud *cloud = [[SPFCloud alloc] init];
    cloud.position = CGPointMake(-64, CGRectGetMidY(self.frame) + [SPFUtilities skRandWithLow:100 andHigh:400]);
    [self addChild:cloud];
}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"cloud" usingBlock:^(SKNode *node, BOOL *stop) {
        [self enumerateChildNodesWithName:@"rain" usingBlock:^(SKNode *node, BOOL *stop) {
            if (node.position.y < 0)
            {
                [node removeFromParent];
            }
        }];
        if (node.position.x > 800)
            [node removeFromParent];
    }];
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *umbrella = [self childNodeWithName:@"umbrella"];
    if (umbrella != nil)
    {
        [umbrella removeAllActions];
        UITouch *touch = [touches allObjects][0];
        CGPoint location = [touch locationInView:touch.view];
        CGFloat distance = fabsf(location.x - umbrella.position.x);
        SKAction *move = [SKAction moveToX:location.x duration:(distance / 500.0)];
        [umbrella runAction:move];
    }
}

- (void)touchesMoved:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *umbrella = [self childNodeWithName:@"umbrella"];
    if (umbrella != nil)
    {
        [umbrella removeAllActions];
        UITouch *touch = [touches allObjects][0];
        CGPoint location = [touch locationInView:touch.view];
        CGFloat distance = fabsf(location.x - umbrella.position.x);
        SKAction *move = [SKAction moveToX:location.x duration:(distance / 500.0)];
        [umbrella runAction:move];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *umbrella = [self childNodeWithName:@"umbrella"];
    if (umbrella != nil)
    {
        [umbrella removeAllActions];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == rainCategory && (contact.bodyB.categoryBitMask == floorCategory || contact.bodyB.categoryBitMask == umbrellaCategory))
    {
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *fadeRain = [SKAction sequence:@[fadeAway, remove]];
        [contact.bodyA.node runAction:fadeRain];
    }
    
    if (contact.bodyB.categoryBitMask == rainCategory && (contact.bodyA.categoryBitMask == floorCategory || contact.bodyA.categoryBitMask == umbrellaCategory))
    {
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *fadeRain = [SKAction sequence:@[fadeAway, remove]];
        [contact.bodyB.node runAction:fadeRain];
    }
}

@end
