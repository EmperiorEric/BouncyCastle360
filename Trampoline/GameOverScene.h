//
//  GameOverScene.h
//  Trampoline
//
//  Created by Ryan Poolos on 9/11/13.
//  Copyright (c) 2013 PopArcade. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene

@property (nonatomic, strong) NSString *scoreString;
@property (nonatomic, strong) NSString *maxHeightString;
@property (nonatomic, strong) NSString *coinsCollected;

@end
