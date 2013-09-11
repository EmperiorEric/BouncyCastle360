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
    SKLabelNode *heightLabel;
    
    SKShapeNode *trampoline;
    
    SKNode *container;
    
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
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectInset(self.frame, 0.0, -CGFLOAT_MAX)];
        [self.physicsWorld setGravity:CGVectorMake(0.0, -5.0)];
        
        heightLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        heightLabel.fontColor = [SKColor whiteColor];
        heightLabel.fontSize = 28.0;
        heightLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - 32.0);
        [self addChild:heightLabel];
        
        container = [SKNode node];
        
        // Create a "Trampoline"
        trampoline = [SKShapeNode node];
        [trampoline setFillColor:[SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
        [trampoline setPath:[UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), 24.0)].CGPath];
        [trampoline setLineWidth:0.0];
        
        trampoline.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(CGRectGetWidth(trampoline.frame), CGRectGetHeight(trampoline.frame))];
        trampoline.physicsBody.usesPreciseCollisionDetection = YES;
        trampoline.physicsBody.restitution = 1.15;
        trampoline.physicsBody.dynamic = NO;
        
        [container addChild:trampoline];
        
        // Create our Player
        player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        player.xScale = 0.1;
        player.yScale = 0.1;
        player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) / 2.0);
        
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.usesPreciseCollisionDetection = YES;
        
        [container addChild:player];
        
        [self addChild:container];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touching = YES;
    
//    [self playerDropping];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    touching = NO;
    
//    [self playerCoasting];
}

-(void)update:(CFTimeInterval)currentTime {
    
    [heightLabel setText:[NSString stringWithFormat:@"%.0f",player.position.y]];
    
    /* Called before each frame is rendered */
    if (touching) {
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, player.physicsBody.velocity.dy + self.physicsWorld.gravity.dy);
    }
    
    CGFloat threshold = 320.0;
    
    CGFloat offset = MAX((player.position.y - threshold), 0.0);
    
    [container setPosition:CGPointMake(0.0, -offset)];
    
    
    BOOL goingDown = player.physicsBody.velocity.dy < 0.0;
    
    if (goingDown) {
        player.zRotation = M_PI;
    } else {
        player.zRotation = 0.0;
    }

    [self setBackgroundColor:[SKColor colorWithRed:player.frame.origin.y/1500.0 green:0.0 blue:0.0 alpha:1.0]];
}

- (void)playerDropping
{
    [player runAction:[SKAction rotateToAngle:M_PI duration:0.5]];
}

- (void)playerCoasting
{
    [player runAction:[SKAction rotateToAngle:0.0 duration:0.5]];
}

@end
