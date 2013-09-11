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
    
    SKSpriteNode *trampoline;
    
    SKNode *container;
    
    SKSpriteNode *player;
    
    CGFloat lastPlayerPosition;
    
    NSMutableArray *frontBalloons;
    NSMutableArray *middleBalloons;
    NSMutableArray *backBalloons;
    
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
        [self.physicsWorld setGravity:CGVectorMake(0.0, -3.27)];
        
        // Create an altitude label
        heightLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        heightLabel.fontColor = [SKColor whiteColor];
        heightLabel.fontSize = 28.0;
        heightLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - 32.0);
        [self addChild:heightLabel];
        
        container = [SKNode node];
        [self addChild:container];
        
        // Create a "Trampoline"
        trampoline = [SKSpriteNode spriteNodeWithImageNamed:@"bouncyCastle"];
        trampoline.position = CGPointMake(CGRectGetMidX(self.frame), 64.0);
        
        trampoline.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(CGRectGetWidth(trampoline.frame), 20.0)];
        trampoline.physicsBody.usesPreciseCollisionDetection = YES;
        trampoline.physicsBody.restitution = 1.15;
        trampoline.physicsBody.dynamic = NO;
        
        [container addChild:trampoline];
        
        // Create some balloons
        frontBalloons = [NSMutableArray array];
        middleBalloons = [NSMutableArray array];
        backBalloons = [NSMutableArray array];
        
        for (int i = 0; i < 25; i++) {
            SKSpriteNode *backBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"party_balloon"];
            backBalloon.xScale = 0.1;
            backBalloon.yScale = 0.1;
            backBalloon.color = [UIColor blackColor];
            backBalloon.colorBlendFactor = 0.4;
            backBalloon.position = CGPointMake(arc4random_uniform(CGRectGetWidth(self.frame)), arc4random_uniform(10000.0) + 1000.0);
            
            [container addChild:backBalloon];
            
            [backBalloons addObject:backBalloon];
            
            SKSpriteNode *middleBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"party_balloon"];
            middleBalloon.xScale = 0.2;
            middleBalloon.yScale = 0.2;
            middleBalloon.color = [UIColor blackColor];
            middleBalloon.colorBlendFactor = 0.2;
            middleBalloon.position = CGPointMake(arc4random_uniform(CGRectGetWidth(self.frame)), arc4random_uniform(10000.0) + 1000.0);
            
            [container addChild:middleBalloon];
            
            [middleBalloons addObject:middleBalloon];
            
            SKSpriteNode *frontBalloon = [SKSpriteNode spriteNodeWithImageNamed:@"party_balloon"];
            frontBalloon.xScale = 0.4;
            frontBalloon.yScale = 0.4;
            frontBalloon.position = CGPointMake(arc4random_uniform(CGRectGetWidth(self.frame)), arc4random_uniform(10000.0) + 1000.0);
            
            [container addChild:frontBalloon];
            
            [frontBalloons addObject:frontBalloon];
        }
        
        // Create our Player
        player = [SKSpriteNode spriteNodeWithImageNamed:@"party_person1"];
        player.xScale = 0.5;
        player.yScale = 0.5;
        player.position = CGPointMake(CGRectGetMidX(self.frame), 300.0);
        
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.usesPreciseCollisionDetection = YES;
        
        [container addChild:player];
        
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

-(void)update:(CFTimeInterval)currentTime
{
    // Update Height Label
    [heightLabel setText:[NSString stringWithFormat:@"%.0f",player.position.y]];
    
    // Adjust Velocity based on touch.
    if (touching) {
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, player.physicsBody.velocity.dy + self.physicsWorld.gravity.dy);
    }
    
    // Visually adjust player based on velocity
    CGFloat speed = fabs(player.physicsBody.velocity.dy);
    // squeeze the player on the x the faster they go.
    player.xScale = MAX(MIN(0.5, 500.0/speed), 0.25);
    // Strech the player on the y the faster they go.
    player.yScale = MAX(MIN(0.75, speed/2000.0), 0.5);
    
    // Keep player in the center of the screen
    CGFloat threshold = 320.0;
    
    CGFloat offset = MAX((player.position.y - threshold), 0.0);
    CGFloat delta = lastPlayerPosition - player.position.y;
    lastPlayerPosition = player.position.y;
    
    [container setPosition:CGPointMake(0.0, -offset)];
    
    // Flip player when going down
    BOOL goingDown = player.physicsBody.velocity.dy < 0.0;
    
    if (goingDown) {
        player.zRotation = M_PI;
    } else {
        player.zRotation = 0.0;
    }
    
    // Balloon
    for (SKSpriteNode *balloon in frontBalloons) {
        [balloon setPosition:CGPointMake(balloon.position.x, (delta / 4.0) + balloon.position.y)];
    }
    
    for (SKSpriteNode *balloon in middleBalloons) {
        [balloon setPosition:CGPointMake(balloon.position.x, (delta / 8.0) + balloon.position.y)];
    }
    
    for (SKSpriteNode *balloon in backBalloons) {
        [balloon setPosition:CGPointMake(balloon.position.x, (delta / 16.0) + balloon.position.y)];
    }
    
    // Adjust sky color based on altitude
    [self setBackgroundColor:[SKColor colorWithRed:0.45-(player.frame.origin.y/3500.0) green:0.65-(player.frame.origin.y/4500.0) blue:2500.0/(player.frame.origin.y) alpha:1.0]];
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
