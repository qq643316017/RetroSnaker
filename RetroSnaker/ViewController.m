//
//  ViewController.m
//  RetroSnaker
//
//  Created by 陈微 on 17/3/29.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import "ViewController.h"
#import "SnakeView.h"

const int cellWidth = 15;        //每个格子的宽
const int cellHeight = 15;       //每个格子的高
const int rowCount = 40;         //行数
const int columnCount = 24;      //列数

@interface ViewController ()

@property (nonatomic,strong) SnakeView *snakeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _snakeView = [[SnakeView alloc] initWithFrame:CGRectMake(20, 0, cellWidth*columnCount, cellHeight*rowCount)];
    [self.view addSubview:_snakeView];
    _snakeView.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"开始游戏" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_snakeView startGame];
    }];
    [alert addAction:startAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
