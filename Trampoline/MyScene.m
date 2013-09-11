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
    
    SKSpriteNode *player2;
    
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
        trampoline = [SKSpriteNode spriteNodeWithImageNamed:@"bouncyCastle"];
        trampoline.position = CGPointMake(CGRectGetMidX(self.frame), 64.0);
        
        trampoline.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(CGRectGetWidth(trampoline.frame), 20.0)];
        trampoline.physicsBody.usesPreciseCollisionDetection = YES;
        trampoline.physicsBody.restitution = 1.15;
        trampoline.physicsBody.dynamic = NO;
        
        [container addChild:trampoline];
        
        // Create our Player
        player = [SKSpriteNode spriteNodeWithImageNamed:@"party_person1"];
        player.xScale = 0.5;
        player.yScale = 0.5;
        player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) / 2.0);
        
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.usesPreciseCollisionDetection = YES;
        
        [container addChild:player];
        
        player2 = [SKSpriteNode spriteNodeWithImageNamed:@"party_person2"];
        player2.xScale = 0.5;
        player2.yScale = 0.5;
        player2.position = CGPointMake(CGRectGetMidX(self.frame), 1000.0);
        
        [container addChild:player2];
        
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
    
    NSLog(@"xScale: %f yScale: %f",1000.0/speed,speed/1000.0);
    
    // Keep player in the center of the screen
    CGFloat threshold = 320.0;
    
    CGFloat offset = MAX((player.position.y - threshold), 0.0);
    
    [container setPosition:CGPointMake(0.0, -offset)];
    
    // Flip player when going down
    BOOL goingDown = player.physicsBody.velocity.dy < 0.0;
    
    if (goingDown) {
        player.zRotation = M_PI;
    } else {
        player.zRotation = 0.0;
    }
    
    // Adjust sky color based on altitude
    [self setBackgroundColor:[SKColor colorWithRed:0.0 green:0.0 blue:5000.0/(player.frame.origin.y * 2.0) alpha:1.0]];
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
