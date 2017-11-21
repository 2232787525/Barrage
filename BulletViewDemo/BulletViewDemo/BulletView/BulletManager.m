//
//  BarrageManager.m
//  BulletViewDemo
//
//  Created by Rainy on 2017/9/14.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()

//正在使用的弹道资源 以弹道数为key 弹道内存在的弹幕array为value
@property(nonatomic,strong)NSMutableDictionary *bulletDic;

//重用队列的资源
@property(nonatomic,strong)NSMutableArray *unusedBulletViews;

//是否是停止状态判断
@property(nonatomic,assign)BOOL isStop;


@end

@implementation BulletManager

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)start {

    _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1+++++",
                                                   @"弹幕2++++++++",
                                                   @"弹幕3++++++++++++",
                                                   @"弹幕4+++++",
                                                   @"弹幕5++++++++",
                                                   @"弹幕6+++++++",
                                                   @"弹幕7+++++",
                                                   @"弹幕8++++++++",
                                                   @"弹幕9++++++++++++++++++++++++++++++++++++++++++",
                                                   @"弹幕10+++++",
                                                   @"弹幕11++++++++",
                                                   @"弹幕12++++++++++"
                                                   ]];
    [self showNewBullet];
}

-(void)showNewBullet{
   
    for (int i=0;i<self.numOfLines ;i++) {
        NSMutableArray *bulletViews = [self.bulletDic objectForKey:[NSString stringWithFormat:@"弹道%d",i]];
        if (bulletViews.count==0) {
            NSString *str = self.dataSource.firstObject;
            if(str){
                [self.dataSource removeObjectAtIndex:0];
                [self createBulletView:str line: i];
                NSLog(@"开辟弹道 %d",i);
            }else{
                break;
            }
        }
    }
}

- (void)createBulletView:(NSString *)content line:(int)line
{
    //初始化弹道view
    BulletView *bulletView;
    //bulletView 复用的过程
    if (self.unusedBulletViews.count>0) {
        bulletView = self.unusedBulletViews[0];
    }

    if(bulletView == nil){
        //创建
        bulletView = [[BulletView alloc]init];
    }
    bulletView.content = content;
    bulletView.line = line;
    
    __weak typeof(bulletView) weakview = bulletView;
    __weak typeof(self) mySelf = self;
    bulletView.movingBlock = ^(moveState state){
        if (self.isStop) {
            return;
        }
        switch (state) {
            case start:{
                NSMutableArray *bullArr = [mySelf.bulletDic objectForKey:[NSString stringWithFormat:@"弹道%d",line]];
                [bullArr addObject:weakview];
                break;
            }
            case enter:{
                //弹幕完全进入屏幕时 如果还有内容将继续获取后面的内容 （递归）
                NSString *content = [mySelf nextContent];
                if (content) {
                    [mySelf createBulletView:content line:line];
                }
                break;
            }
            case end:{
                //动画结束处理
                [weakview stopAnimation];
                NSMutableArray *bullArr = [mySelf.bulletDic objectForKey:[NSString stringWithFormat:@"弹道%d",line]];
                [bullArr removeObject:weakview];
                
                break;
            }
            default:
                break;
        }
    };
    
    //逐个将弹幕view回调
    if (self.generrateViewBlock) {
        self.generrateViewBlock(bulletView);
    }
}

- (NSString *)nextContent {
    if (self.dataSource.count == 0) {
        return nil;
    }
    NSString *content = [self.dataSource firstObject];
    if (content) {
        [self.dataSource removeObjectAtIndex:0];
    }
    return content;
}


- (void)stop {
    [self.dataSource removeAllObjects];
}


-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1+++++",
                                                       @"弹幕2++++++++",
                                                       @"弹幕3++++++++++++",
                                                       @"弹幕4+++++",
                                                       @"弹幕5++++++++",
                                                       @"弹幕6+++++++",
                                                       @"弹幕7+++++",
                                                       @"弹幕8++++++++",
                                                       @"弹幕9++++++++++++++++++++++++++++++++++++++++++",
                                                       @"弹幕10+++++",
                                                       @"弹幕11++++++++",
                                                       @"弹幕12++++++++++"
                                                       ]];
    }
    return _dataSource;
}
-(NSMutableDictionary *)bulletDic{
    if (_bulletDic.count<_numOfLines) {
        _bulletDic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i=0; i<_numOfLines; i++) {
            [_bulletDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"弹道%d",i]];
        }
    }
    return _bulletDic;
}

-(NSMutableArray *)unusedBulletViews
{
    if (!_unusedBulletViews) {
        
        _unusedBulletViews = [NSMutableArray array];
    }
    return _unusedBulletViews;
}

@end
