//
//  Platform.h
//  JumpTest
//
//  Created by Cody Mace on 1/14/14.
//  Copyright (c) 2014 Cody Mace. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Platform : SKSpriteNode

@property (assign, nonatomic)NSInteger hitPoints;

+ (Platform *)platformWithPosition:(NSInteger)x y:(NSInteger)y height:(double)height width:(double)width;

- (id)initWithPosition:(NSInteger)x y:(NSInteger)y height:(double)height width:(double)width;

- (void)move;

@end
