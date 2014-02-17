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
#import "Player.h"
#import "JSTileMap.h"

@interface MyScene()

@property (nonatomic) Jumper *jumperOne;
@property (nonatomic) Platform *platform;
@property (nonatomic) SKSpriteNode *bgImage;
@property (assign, nonatomic) NSInteger shipCount;
@property (strong, nonatomic) NSMutableArray *shipArray;
@property (strong, nonatomic) NSMutableArray *platformArray;

@property (nonatomic, strong) JSTileMap *map;
@property (nonatomic, strong) Player *player;
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;
@property (nonatomic, strong) TMXLayer *walls;
@property (nonatomic, strong) TMXLayer *hazards;
@property (nonatomic, assign) BOOL gameOver;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

        self.backgroundColor = [SKColor colorWithRed:.4 green:.4 blue:.95 alpha:1.0];

        self.map = [JSTileMap mapNamed:@"level1.tmx"];
        [self addChild:self.map];
        self.walls = [self.map layerNamed:@"walls"];
        self.hazards = [self.map layerNamed:@"hazards"];

        self.player = [[Player alloc] initWithImageNamed:@"koalio_stand"];
        self.player.position = CGPointMake(100, 50);
        self.player.zPosition = 15;
        [self.map setScale:4];
        [self.map addChild:self.player];
        
        self.bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Field-landscape"];
        [self.bgImage setScale:10];
        [self.bgImage setPosition:CGPointMake(2800, 1000)];
//        [self addChild:self.bgImage];
        self.shipCount = 0;
        //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.shipArray = [[NSMutableArray alloc] init];

        Jumper *jumper = [Jumper jumperWithKey:'j' Position:CGPointMake(500, 600)];
        [self.shipArray addObject:jumper];
        [self addChild:jumper];
//        self.platformArray = [[NSMutableArray alloc] init];
//        Platform *ground = [Platform platformWithPosition:28 y:0 height:60 width:self.bgImage.size.width];
//        Platform *p1 = [Platform platformWithPosition:30 y:0 height:50 width:300];
//        Platform *p2 = [Platform platformWithPosition:35 y:8 height:50 width:300];
//        Platform *p3 = [Platform platformWithPosition:40 y:16   height:50 width:300];
//        [self.platformArray addObject:ground];
//        [self.platformArray addObject:p1];
//        [self.platformArray addObject:p2];
//        [self.platformArray addObject:p3];
//        [self.platformArray enumerateObjectsUsingBlock:^(Platform *platform, NSUInteger idx, BOOL *stop) {
//        [self addChild:platform];
//        }];
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
            if (character == 'j')
            {
                self.player.mightAsWellJump = YES;
        }
            if (character == ship.key)
            {
                NSLog(@"%hu", ship.key);
//                [ship jump];
            }
        }];
        NSLog(@"%lu", (unsigned long)self.shipArray.count);
    }
}
- (void)keyUp:(NSEvent *)theEvent
{
    NSString *characters = [theEvent characters];
    for (int s = 0; s<[characters length]; s++)
    {
        unichar character = [characters characterAtIndex:s];
        if (character == 'j')
        {
            self.player.mightAsWellJump = NO;
        }
    }
}

//1
- (void)update:(NSTimeInterval)currentTime
{
    if (self.gameOver) return;
    float newX = self.bgImage.position.x - ConstantScrollSpeed;
//    self.bgImage.position = CGPointMake(newX, self.bgImage.position.y);
//    [self.platformArray enumerateObjectsUsingBlock:^(Platform *platform, NSUInteger idx, BOOL *stop) {
//        [platform move];
//    }];

    //2
    NSTimeInterval delta = currentTime - self.previousUpdateTime;
    //3
    if (delta > 0.02) {
        delta = 0.02;
    }
    //4
    self.previousUpdateTime = currentTime;
    //5
    [self.player update:delta];
    
    [self checkForAndResolveCollisionsForPlayer:self.player forLayer:self.walls];
    [self handleHazardCollisions:self.player];
    [self checkForWin];

    [self setViewpointCenter:self.player.position];

    self.player.forwardMarch = YES;
}

- (void)checkForAndResolveCollisionsForPlayer:(Player *)player forLayer:(TMXLayer *)layer
{
    NSInteger indices[8] = {7, 1, 3, 5, 0, 2, 6, 8};
    player.onGround = NO;  ////Here
    for (NSUInteger i = 0; i < 8; i++) {
        NSInteger tileIndex = indices[i];

        CGRect playerRect = [player collisionBoundingBox];
        CGPoint playerCoord = [layer coordForPoint:player.desiredPosition];
        if (playerCoord.y >= self.map.mapSize.height - 1) {
            [self gameOver:0];
            return;
        }

        NSInteger tileColumn = tileIndex % 3;
        NSInteger tileRow = tileIndex / 3;
        CGPoint tileCoord = CGPointMake(playerCoord.x + (tileColumn - 1), playerCoord.y + (tileRow - 1));

        NSInteger gid = [self tileGIDAtTileCoord:tileCoord forLayer:layer];
        if (gid != 0) {
            CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
            //NSLog(@"GID %ld, Tile Coord %@, Tile Rect %@, player rect %@", (long)gid, NSStringFromCGPoint(tileCoord), NSStringFromCGRect(tileRect), NSStringFromCGRect(playerRect));
            //1
            if (CGRectIntersectsRect(playerRect, tileRect)) {
                CGRect intersection = CGRectIntersection(playerRect, tileRect);
                //2
                if (tileIndex == 7) {
                    //tile is directly below Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y + intersection.size.height);
                    player.velocity = CGPointMake(player.velocity.x, 0.0); ////Here
                    player.onGround = YES; ////Here
                } else if (tileIndex == 1) {
                    //tile is directly above Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y - intersection.size.height);
                } else if (tileIndex == 3) {
                    //tile is left of Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x + intersection.size.width, player.desiredPosition.y);
                } else if (tileIndex == 5) {
                    //tile is right of Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x - intersection.size.width, player.desiredPosition.y);
                    //3
                } else {
                    if (intersection.size.width > intersection.size.height) {
                        //tile is diagonal, but resolving collision vertically
                        //4
                        player.velocity = CGPointMake(player.velocity.x, 0.0); ////Here
                        float intersectionHeight;
                        if (tileIndex > 4) {
                            intersectionHeight = intersection.size.height;
                            player.onGround = YES; ////Here
                        } else {
                            intersectionHeight = -intersection.size.height;
                        }
                        player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y + intersection.size.height );
                    } else {
                        //tile is diagonal, but resolving horizontally
                        float intersectionWidth;
                        if (tileIndex == 6 || tileIndex == 0) {
                            intersectionWidth = intersection.size.width;
                        } else {
                            intersectionWidth = -intersection.size.width;
                        }
                        //5
                        player.desiredPosition = CGPointMake(player.desiredPosition.x  + intersectionWidth, player.desiredPosition.y);
                    }
                }
            }
        }
    }
    //6
    player.position = player.desiredPosition;
}

- (void)setViewpointCenter:(CGPoint)position {
    NSInteger x = MAX(position.x*4, self.size.width / 2);
    NSInteger y = MAX(position.y*4, self.size.height / 2);
    x = MIN(x, (self.map.mapSize.width * self.map.tileSize.width)*4);// - self.size.width / 1);
    y = MIN(y, (self.map.mapSize.height * self.map.tileSize.height)*2.5);// - self.size.height / 2);
    CGPoint actualPosition = CGPointMake(x, y);
    CGPoint centerOfView = CGPointMake(self.size.width/2, self.size.height/2);
    CGPoint viewPoint = CGPointMake(centerOfView.x - actualPosition.x, centerOfView.y - actualPosition.y);
    self.map.position = viewPoint;
}

- (void)handleHazardCollisions:(Player *)player
{
    if (self.gameOver) return;

    NSInteger indices[8] = {7, 1, 3, 5, 0, 2, 6, 8};

    for (NSUInteger i = 0; i < 8; i++) {
        NSInteger tileIndex = indices[i];

        CGRect playerRect = [player collisionBoundingBox];
        CGPoint playerCoord = [self.hazards coordForPoint:player.desiredPosition];

        NSInteger tileColumn = tileIndex % 3;
        NSInteger tileRow = tileIndex / 3;
        CGPoint tileCoord = CGPointMake(playerCoord.x + (tileColumn - 1), playerCoord.y + (tileRow - 1));

        NSInteger gid = [self tileGIDAtTileCoord:tileCoord forLayer:self.hazards];
        if (gid != 0) {
            CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
            if (CGRectIntersectsRect(playerRect, tileRect)) {
                [self gameOver:0];
            }
        }
    }
}

-(void)gameOver:(BOOL)won {
    //1
    self.gameOver = YES;
    //2
    NSString *gameText;
    if (won) {
        gameText = @"You Won!";
    } else {
        gameText = @"You have Died!";
    }

    //3
    SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    endGameLabel.text = gameText;
    endGameLabel.fontSize = 40;
    endGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.7);
    [self addChild:endGameLabel];

    //4
    NSImage *replayImage = [NSImage imageNamed:@"replay"];
    CGRect frame = CGRectMake(self.size.width / 2.0 - replayImage.size.width / 2.0, self.size.height / 2.0 - replayImage.size.height / 2.0, replayImage.size.width, replayImage.size.height);
    NSButton *replay = [[NSButton alloc] initWithFrame:frame];
    replay.tag = 321;
    [replay setImage:replayImage];
    [replay setTarget:self];
    [replay setAction:@selector(replay:)];
    [self.view addSubview:replay];
    NSLog(@"add replay");
}
-(void)checkForWin {
    if (self.player.position.x > 3130.0) {
        [self gameOver:1];
    }
}
- (void)replay:(id)sender
{
    //5
    [[self.view viewWithTag:321] removeFromSuperview];
    //6
    [self.view presentScene:[[MyScene alloc] initWithSize:self.size]];
}

//helpers//
-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
    float levelHeightInPixels = self.map.mapSize.height * self.map.tileSize.height;
    CGPoint origin = CGPointMake(tileCoords.x * self.map.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * self.map.tileSize.height));
    return CGRectMake(origin.x, origin.y, self.map.tileSize.width, self.map.tileSize.height);
}

- (NSInteger)tileGIDAtTileCoord:(CGPoint)coord forLayer:(TMXLayer *)layer {
    TMXLayerInfo *layerInfo = layer.layerInfo;
    return [layerInfo tileGidAtCoord:coord];
}

@end
