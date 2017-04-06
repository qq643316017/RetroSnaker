//
//  SnakeView.h
//  RetroSnaker
//
//  Created by 陈微 on 17/3/29.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SnakeDirection){
    SnakeDirectionRight  = 1 << 0,
    SnakeDirectionLeft = 1 << 1,
    SnakeDirectionUp    = 1 << 2,
    SnakeDirectionDown  = 1 << 3,
};

@interface SnakeView : UIView

- (void)startGame;

@end
