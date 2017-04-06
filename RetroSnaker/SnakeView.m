//
//  SnakeView.m
//  RetroSnaker
//
//  Created by 陈微 on 17/3/29.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import "SnakeView.h"
#import "SnakePoint.h"

UIKIT_EXTERN const int cellWidth;           //每个格子的宽
UIKIT_EXTERN const int cellHeight;          //每个格子的高
UIKIT_EXTERN const int rowCount;            //行数
UIKIT_EXTERN const int columnCount;         //列数

const int snakeStartCount = 5;             //开始蛇的长度
const int addRateOfEatFoodCount = 10;          //每吃几个食物就开始加速

@interface SnakeView ()<UIAlertViewDelegate>

@property (nonatomic,strong) NSMutableArray *allPointArr;  //存放蛇的所有点的数组
@property (nonatomic,assign) SnakeDirection direction;     //蛇的行动方向
@property (nonatomic,strong) NSTimer *runTimer;
@property (nonatomic,strong) SnakePoint *foodPoint;        //食物点

@property (nonatomic,assign) CGFloat snakeRunRate;        //这个属性控制蛇的移动速度

@end

@implementation SnakeView

- (UIViewController *)viewController
{
    //下一个响应者
    UIResponder *next=[self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next=[next nextResponder];
    } while (next!=nil);
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor yellowColor];
        _allPointArr = [NSMutableArray arrayWithCapacity:0];
        
        for(int i=0; i<4; i++){
            UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeSnakeDirection:)];
            swipeGesture.direction = 1 << i;
            swipeGesture.numberOfTouchesRequired = 1;
            [self addGestureRecognizer:swipeGesture];
        }
    }
    
    return self;
}

- (void)startGame
{
    [_allPointArr removeAllObjects];
    _direction = SnakeDirectionRight;
    _snakeRunRate = 0.5;
    for(int i=0; i<snakeStartCount; i++){
        SnakePoint *point = [[SnakePoint alloc] initWithX:snakeStartCount-i y:0];
        [_allPointArr addObject:point];
    }
    
    [self creatFoodPoint];
    
    [self setNeedsDisplay];
    
    [self addRunTimer];
}

- (void)addRunTimer
{
    if(_runTimer){
        [_runTimer invalidate];
    }
    __weak SnakeView *weakSelf = self;
    _runTimer = [NSTimer timerWithTimeInterval:_snakeRunRate repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf snakeRun];
    }];
    [[NSRunLoop currentRunLoop] addTimer:_runTimer forMode:NSRunLoopCommonModes];
}

- (void)changeSnakeDirection:(UISwipeGestureRecognizer *)gesture
{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionRight:{
            if(_direction != SnakeDirectionLeft){
                _direction = SnakeDirectionRight;
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:{
            if(_direction != SnakeDirectionRight){
                _direction = SnakeDirectionLeft;
            }
        }
            
            break;
        case UISwipeGestureRecognizerDirectionUp:{
            if(_direction != SnakeDirectionDown){
                _direction = SnakeDirectionUp;
            }
        }
            
            break;
        case UISwipeGestureRecognizerDirectionDown:{
            if(_direction != SnakeDirectionUp){
                _direction = SnakeDirectionDown;
            }
        }
            
            break;
            
        default:
            break;
    }
}

- (void)endGame
{
    [_runTimer invalidate];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"游戏结束" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self startGame];
    }];
    [alert addAction:startAction];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}


- (void)creatFoodPoint
{
    SnakePoint *point = [SnakePoint alloc];
    do{
        point.x = arc4random()%columnCount;
        point.y = arc4random()%rowCount;
        //        NSLog(@"x is %ld, y is %ld",(long)point.x,(long)point.y);
    }while ([point isInArr:_allPointArr]);
    
    _foodPoint = point;
}

//增加蛇的移动速度
- (void)addSnakeRunRate
{
    NSInteger index = (_allPointArr.count-snakeStartCount)/addRateOfEatFoodCount;
    NSInteger remainder = (_allPointArr.count-snakeStartCount) % addRateOfEatFoodCount;
    if(remainder == 0){
        _snakeRunRate = 0.5 - 0.1*index;
        if(_snakeRunRate < 0.1){
            _snakeRunRate = 0.1;
        }
        
        [self addRunTimer];
    }
}

- (void)snakeRun
{
    SnakePoint *headPoint = _allPointArr[0];
    SnakePoint *nextPoint = [[SnakePoint alloc] initWithX:0 y:0];
    switch (_direction) {
        case SnakeDirectionLeft:{
            nextPoint.y = headPoint.y;
            nextPoint.x = headPoint.x-1;
        }
            break;
        case SnakeDirectionRight:{
            nextPoint.y = headPoint.y;
            nextPoint.x = headPoint.x+1;
        }
            break;
        case SnakeDirectionUp:{
            nextPoint.y = headPoint.y-1;
            nextPoint.x = headPoint.x;
        }
            break;
        case SnakeDirectionDown:{
            nextPoint.y = headPoint.y+1;
            nextPoint.x = headPoint.x;
        }
            break;
            
        default:
            break;
    }
    
    if(nextPoint.x >= columnCount || nextPoint.x < 0 || nextPoint.y < 0 || nextPoint.y >= rowCount || [nextPoint isInArr:[_allPointArr subarrayWithRange:NSMakeRange(0, _allPointArr.count-1)]]){
        //游戏结束
        [self endGame];
        return;
    }
    
    if([nextPoint isEqualToPoint:_foodPoint]){
        //吃掉食物
        [_allPointArr insertObject:_foodPoint atIndex:0];
        [self creatFoodPoint];
        [self addSnakeRunRate];
    }else{
        //整体往前走一步(后一个点总是走到前一个点的位置)
        for(NSInteger i=_allPointArr.count-1; i>=0; i--){
            SnakePoint *point = _allPointArr[i];
            if(i == 0){
                point.x = nextPoint.x;
                point.y = nextPoint.y;
            }else{
                SnakePoint *fowardPoint = _allPointArr[i-1];
                point.x = fowardPoint.x;
                point.y = fowardPoint.y;
            }
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    __weak SnakeView *weakSelf = self;
    [_allPointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SnakePoint *point = (SnakePoint *)obj;
        CGRect rect = CGRectMake(point.x*cellWidth, point.y*cellHeight, cellWidth, cellHeight);
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        if(idx > _allPointArr.count-3){
            NSInteger scale = 3 - (_allPointArr.count - idx);
            CGContextFillEllipseInRect(context, CGRectInset(rect, scale, scale));
        }else if(idx == 0){
            [weakSelf drawRectHeadPointInRect:rect context:context];
        }else{
            CGContextFillEllipseInRect(context, rect);
        }
    }];
    
    if(_foodPoint){
        CGRect rect = CGRectMake(_foodPoint.x*cellWidth, _foodPoint.y*cellHeight, cellWidth, cellHeight);
        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextFillEllipseInRect(context, rect);
    }
}

//画蛇头
- (void)drawRectHeadPointInRect:(CGRect)rect context:(CGContextRef)context
{
    CGContextBeginPath(context);
    CGFloat startAngle = 0;
    switch (_direction) {
        case SnakeDirectionRight:
            startAngle = M_PI * 1/4;
            break;
        case SnakeDirectionLeft:
            startAngle = M_PI * 5/4;
            break;
        case SnakeDirectionUp:
            startAngle = M_PI * 7/4;
            break;
        case SnakeDirectionDown:
            startAngle = M_PI * 3/4;
            break;
        default:
            break;
    }
    
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), cellWidth/2, startAngle, M_PI*1.5+startAngle, 0);
    CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end
