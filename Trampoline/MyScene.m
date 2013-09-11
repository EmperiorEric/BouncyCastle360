//
//  MyScene.m
//  Trampoline
//
//  Created by Ryan Poolos on 9/10/13.
//  Copyright (c) 2013 PopArcade. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()
{
    SKShapeNode *trampoline;
    SKSpriteNode *player;
    
    BOOL touching;
}
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // Initialize our physicsWorld
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // Create a "Trampoline"
        trampoline = [SKShapeNode node];
        [trampoline setFillColor:[SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
        [trampoline setPath:[UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), 50.0)].CGPath];
        [trampoline setLineWidth:0.0];
        
        trampoline.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(CGRectGetWidth(trampoline.frame), CGRectGetHeight(trampoline.frame))];
        trampoline.physicsBody.usesPreciseCollisionDetection = YES;
        trampoline.physicsBody.restitution = 0.99;
        trampoline.physicsBody.dynamic = NO;
        
        [self addChild:trampoline];
        
        // Create our Player
        player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        player.xScale = 0.25;
        player.yScale = 0.25;
        player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.usesPreciseCollisionDetection = YES;
        
        [self addChild:player];
        

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touching = YES;
//    player.physicsBody.angularDamping = 0.0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    touching = NO;
//    player.physicsBody.angularDamping = 1.0;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (touching) {
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, player.physicsBody.velocity.dy - 10.0);
    }
}

@end
