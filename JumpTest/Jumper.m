//
//  Jumper.m
//  JumpTest
//
//  Created by Cody Mace on 1/8/14.
//  Copyright (c) 2014 Cody Mace. All rights reserved.
//

#import "Jumper.h"


@implementation Jumper

+ (Jumper *)jumperWithKey:(unichar)key Position:(CGPoint)position
{
    Jumper *jumper = [[Jumper alloc] initWithKey:key Position:position];
    return jumper;
}


- (id)initWithKey:(unichar)key Position:(CGPoint)position
{
    self = [super initWithImageNamed:@"Spaceship"];//@"aang_air_attack_by_senshisprite-d49amm9"];//@"Spaceship"];
    if (self)
    {
        self.position = position;
        self.scale = 0.4;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.friction = 0.9;
        self.key = key;

    }
    return self;
}

- (void)jump
{
    [self.physicsBody applyImpulse:CGVectorMake(0, 700)];
}

@end
