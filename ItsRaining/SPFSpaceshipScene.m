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
#import "SPFPerson.h"

@interface SPFSpaceshipScene ()

@property BOOL contentCreated;
@property NSMutableOrderedSet *currentTouches;
@property NSInteger *currentNumberOfHitPeople;

@end

@implementation SPFSpaceshipScene

@synthesize currentTouches;
@synthesize currentNumberOfHitPeople;

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
    currentTouches = [[NSMutableOrderedSet alloc] init];
    currentNumberOfHitPeople = 0;
    
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.contactDelegate = self;
    
    [self addChild:[self newScoreLabel]];
    
    [self addChild:[self newFloor]];
    
    SKSpriteNode *umbrella = [self newUmbrella];
    umbrella.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 300);
    [self addChild:umbrella];
    
    SKAction *makeItRain = [SKAction sequence:@[[SKAction performSelector:@selector(addCloud) onTarget:self],
                                                [SKAction waitForDuration:2 withRange:1]]];
    SKAction *makeItAlwaysRain = [SKAction repeatActionForever:makeItRain];
    [self runAction:makeItAlwaysRain];
    
    SKAction *makePeople = [SKAction sequence:@[[SKAction performSelector:@selector(addPerson) onTarget:self],
                                                [SKAction waitForDuration:3 withRange:2]]];
    SKAction *makePeopleContinuously = [SKAction repeatActionForever:makePeople];
    [self runAction:makePeopleContinuously];
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
    floor.physicsBody.contactTestBitMask = rainCategory | personCategory;
    floor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -500.0);
    
    return floor;
}

- (SKLabelNode *)newScoreLabel
{
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-BoldItalic"];
    scoreLabel.name = @"scoreLabel";
    scoreLabel.text = [NSString stringWithFormat:@"%d", (int)currentNumberOfHitPeople];
    scoreLabel.fontSize = 42;
    scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - scoreLabel.frame.size.width ,CGRectGetMaxY(self.frame) - scoreLabel.frame.size.height);
    return scoreLabel;
}

- (void)addCloud
{
    SPFCloud *cloud = [[SPFCloud alloc] init];
    cloud.position = CGPointMake(-64, CGRectGetMidY(self.frame) + [SPFUtilities skRandWithLow:100 andHigh:400]);
    [self addChild:cloud];
}

- (void)addPerson
{
    SPFPerson *person = [[SPFPerson alloc] init];
    person.position = CGPointMake(800, CGRectGetMidY(self.frame) - 484);
    [self addChild:person];
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
        UITouch *touch = [touches allObjects][0];
        CGPoint location = [touch locationInView:touch.view];
        CGFloat distance = fabsf(location.x - umbrella.position.x);
        SKAction *move = [SKAction moveToX:location.x duration:(distance / 500.0)];
        [umbrella runAction:move];
        [currentTouches addObject:touch];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *umbrella = [self childNodeWithName:@"umbrella"];
    if (umbrella != nil)
    {
        UITouch *touch = [touches allObjects][0];
        [currentTouches removeObject:touch];
        if (currentTouches.count > 0)
        {
            UITouch *oldTouch = [currentTouches lastObject];
            CGPoint location = [oldTouch locationInView:touch.view];
            CGFloat distance = fabsf(location.x - umbrella.position.x);
            SKAction *move = [SKAction moveToX:location.x duration:(distance / 500.0)];
            [umbrella runAction:move];
        }
        else
        {
            [umbrella removeAllActions];
        }
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // Contact is always between rain and something else.
    SKPhysicsBody *rainBody;
    SKPhysicsBody *otherBody;
    if (contact.bodyA.categoryBitMask == rainCategory)
    {
        rainBody = contact.bodyA;
        otherBody = contact.bodyB;
    }
    else if (contact.bodyB.categoryBitMask == rainCategory)
    {
        rainBody = contact.bodyB;
        otherBody = contact.bodyA;
    }
    
    if (otherBody.categoryBitMask == floorCategory || otherBody.categoryBitMask == umbrellaCategory)
    {
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *fadeRain = [SKAction sequence:@[fadeAway, remove]];
        [rainBody.node runAction:fadeRain];
    }
    
    if (otherBody.categoryBitMask == personCategory)
    {
        SPFPerson *person = (SPFPerson *)otherBody.node;
        if (!person.isWet)
        {
            person.isWet = YES;
            SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *fadeObject = [SKAction sequence:@[fadeAway, remove]];
            [rainBody.node runAction:fadeObject];
            [otherBody.node runAction:fadeObject];
        
            currentNumberOfHitPeople++;
            SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"scoreLabel"];
            scoreLabel.text = [NSString stringWithFormat:@"%d", (int)currentNumberOfHitPeople];
        }
    }
}

@end
