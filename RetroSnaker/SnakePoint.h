//
//  SnakePoint.h
//  RetroSnaker
//
//  Created by 陈微 on 17/3/29.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SnakePoint : NSObject

@property (nonatomic,assign) NSInteger x;   //x行索引
@property (nonatomic,assign) NSInteger y;   //y列索引

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y;
- (BOOL)isInArr:(NSArray *)pointArr;   //当前点是否在这个数组的点内
- (BOOL)isEqualToPoint:(SnakePoint *)point;  //判断两个点是否相等

@end
