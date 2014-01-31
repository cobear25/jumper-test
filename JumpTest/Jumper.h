//
//  Jumper.h
//  JumpTest
//
//  Created by Cody Mace on 1/8/14.
//  Copyright (c) 2014 Cody Mace. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Jumper : SKSpriteNode

@property (assign, nonatomic) unichar key;

+ (Jumper *)jumperWithKey:(unichar)key Position:(CGPoint)position;
- (id)initWithKey:(unichar)key Position:(CGPoint)position;
- (void)jump;
@end
