//
//  GameOverScene.m
//  Trampoline
//
//  Created by Ryan Poolos on 9/11/13.
//  Copyright (c) 2013 PopArcade. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"

@implementation GameOverScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
        
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        scoreLabel.fontColor = [SKColor colorWithRed:0.0 green:0.75 blue:0.0 alpha:1.0];
        scoreLabel.fontSize = 36.0;
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 128.0);
        
        scoreLabel.text = @"Play Again!";
        
        [self addChild:scoreLabel];
    }
    
    return self;
}

- (void)setScoreString:(NSString *)scoreString
{
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.fontSize = 36.0;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - 128.0);
    
    scoreLabel.text = scoreString;
    
    [self addChild:scoreLabel];
}

- (void)setMaxHeightString:(NSString *)maxHeightString
{
    SKLabelNode *heightLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    heightLabel.fontColor = [SKColor whiteColor];
    heightLabel.fontSize = 24.0;
    heightLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - 196.0);
    
    heightLabel.text = maxHeightString;
    
    [self addChild:heightLabel];
}

- (void)setCoinsCollected:(NSString *)coinsCollected
{
    SKLabelNode *coinsLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    coinsLabel.fontColor = [SKColor whiteColor];
    coinsLabel.fontSize = 24.0;
    coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - 256.0);
    
    coinsLabel.text = coinsCollected;
    
    [self addChild:coinsLabel];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self playAgain];
}

- (void)playAgain
{
    [self.view presentScene:[MyScene sceneWithSize:self.size] transition:[SKTransition doorsOpenHorizontalWithDuration:0.5]];
}

@end
