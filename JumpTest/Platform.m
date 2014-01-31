//
//  Platform.m
//  JumpTest
//
//  Created by Cody Mace on 1/14/14.
//  Copyright (c) 2014 Cody Mace. All rights reserved.
//

#import "Platform.h"
#import "Constants.h"

@interface Platform()

@property (assign, nonatomic) BOOL movingRight;

@end
@implementation Platform

+ (Platform *)platformWithPosition:(NSInteger)x y:(NSInteger)y height:(double)height width:(double)width;
{
    Platform *platform = [[Platform alloc] initWithPosition:x y:y height:height width:width];
    return platform;
}

- (id)initWithPosition:(NSInteger)x y:(NSInteger)y height:(double)height width:(double)width;
{
    self = [super initWithColor:[NSColor purpleColor] size:CGSizeMake(width, height)];
    if (self)
    {
        self.position = CGPointMake(x*100, (y+self.size.height/2)+(y*10));
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.mass = 50;
        self.physicsBody.dynamic = NO;
        self.physicsBody.friction = .9;
        //self.zRotation = M_PI/6;
        self.movingRight = true;
    }
    return self;
}

- (void)move
{
    self.position = CGPointMake(self.position.x - ConstantScrollSpeed, self.position.y);
}

@end
