//
//  SnakePoint.m
//  RetroSnaker
//
//  Created by 陈微 on 17/3/29.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import "SnakePoint.h"

@implementation SnakePoint

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y
{
    self = [super init];
    if(self){
        _x = x;
        _y = y;
    }
    
    return self;
}

- (BOOL)isInArr:(NSArray *)pointArr
{
    for(SnakePoint *point in pointArr){
        if([self isEqualToPoint:point]){
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isEqualToPoint:(SnakePoint *)point
{
    return (_x == point.x && _y == point.y);
}

@end
