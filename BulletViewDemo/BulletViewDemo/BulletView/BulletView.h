//
//  BulletView.h
//  BulletViewDemo
//
//  Created by Rainy on 2017/9/14.
//  Copyright © 2017年 Rainy. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface BulletView : UIView

//弹幕移动位置的状态
typedef NS_ENUM(NSUInteger, moveState) {
    start,//开始移动
    enter,//完全进入屏幕
    end,//完全离开屏幕
};

//第几条弹道
@property(nonatomic,assign)int line;

@property(nonatomic,copy)NSString *content;

//状态回调
@property(nonatomic,copy)void(^movingBlock)(moveState);

- (void)startAnimation;

- (void)stopAnimation;

@end
