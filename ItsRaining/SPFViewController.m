//
//  SPFViewController.m
//  ItsRaining
//
//  Created by Simon Fry on 14/12/2013.
//  Copyright (c) 2013 Simon Fry. All rights reserved.
//

#import "SPFViewController.h"
#import "SPFHelloScene.h"
#import <SpriteKit/SpriteKit.h>

@interface SPFViewController ()

@end

@implementation SPFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    SPFHelloScene* hello = [[SPFHelloScene alloc] initWithSize:CGSizeMake(768,1024)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene: hello];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
