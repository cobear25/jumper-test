//
//  MyScene.m
//  JumpTest
//
//  Created by Cody Mace on 1/7/14.
//  Copyright (c) 2014 Cody Mace. All rights reserved.
//

#import "MyScene.h"
#import "Constants.h"
#import "Jumper.h"
#import "Platform.h"

@interface MyScene()

@property (nonatomic) Jumper *jumperOne;
@property (nonatomic) Platform *platform;
@property (nonatomic) SKSpriteNode *bgImage;
@property (assign, nonatomic) NSInteger shipCount;
@property (strong, nonatomic) NSMutableArray *shipArray;
@property (strong, nonatomic) NSMutableArray *platformArray;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        self.bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Field-landscape"];
        [self.bgImage setScale:10];
        [self.bgImage setPosition:CGPointMake(2800, 1000)];
        [self addChild:self.bgImage];
        self.shipCount = 0;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self addChild:myLabel];
        self.shipArray = [[NSMutableArray alloc] init];

        Jumper *jumper = [Jumper jumperWithKey:'j' Position:CGPointMake(500, 600)];
        [self.shipArray addObject:jumper];
        [self addChild:jumper];
        self.platformArray = [[NSMutableArray alloc] init];
        Platform *ground = [Platform platformWithPosition:28 y:0 height:60 width:self.bgImage.size.width];
        Platform *p1 = [Platform platformWithPosition:30 y:0 height:50 width:300];
        Platform *p2 = [Platform platformWithPosition:35 y:8 height:50 width:300];
        Platform *p3 = [Platform platformWithPosition:40 y:16 height:50 width:300];
        [self.platformArray addObject:ground];
        [self.platformArray addObject:p1];
        [self.platformArray addObject:p2];
        [self.platformArray addObject:p3];
        [self.platformArray enumerateObjectsUsingBlock:^(Platform *platform, NSUInteger idx, BOOL *stop) {
        [self addChild:platform];
        }];
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    Jumper *ship;
    switch (self.shipCount)
    {
        case 0:
            ship = [Jumper jumperWithKey:';' Position:location];
            break;
        case 1:
            ship = [Jumper jumperWithKey:'l' Position:location];
            break;
        case 2:
            ship = [Jumper jumperWithKey:'k' Position:location];
            break;
        case 3:
            ship = [Jumper jumperWithKey:'j' Position:location];
            break;
        case 4:
            ship = [Jumper jumperWithKey:'f' Position:location];
            break;
        case 5:
            ship = [Jumper jumperWithKey:'d' Position:location];
            break;
        case 6:
            ship = [Jumper jumperWithKey:'s' Position:location];
            break;
        case 7:
            ship = [Jumper jumperWithKey:'a' Position:location];
            break;
            
        default:
            break;
    }
    [self addChild:ship];
    [self.shipArray addObject:ship];
    self.shipCount ++;
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSString *characters = [theEvent characters];
    for (int s = 0; s<[characters length]; s++) {
        unichar character = [characters characterAtIndex:s];
        [self.shipArray enumerateObjectsUsingBlock:^(Jumper *ship, NSUInteger idx, BOOL *stop) {
            if (character == ship.key)
            {
                NSLog(@"%hu", ship.key);
                [ship jump];
            }
        }];
        NSLog(@"%lu", (unsigned long)self.shipArray.count);
    }
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    float newX = self.bgImage.position.x - ConstantScrollSpeed;
    self.bgImage.position = CGPointMake(newX, self.bgImage.position.y);
    [self.platformArray enumerateObjectsUsingBlock:^(Platform *platform, NSUInteger idx, BOOL *stop) {
        [platform move];
    }];
}


@end
