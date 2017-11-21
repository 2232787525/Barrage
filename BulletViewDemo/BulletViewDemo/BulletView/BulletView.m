//
//  BulletView.m
//  BulletViewDemo
//
//  Created by Rainy on 2017/9/14.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#define margin 10
#define IMG_height 40

#import "BulletView.h"

@interface BulletView ()

@property(nonatomic,strong)UILabel *lbContent;
@property(nonatomic,strong)UIImageView *hearderIMG;

@end

@implementation BulletView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init]) {
        
        /*
         *   UI布局
         **/
        
        
        self.backgroundColor = [UIColor redColor];

        self.hearderIMG.frame = CGRectMake(-5, -10, IMG_height, IMG_height);
        self.hearderIMG.image = [UIImage imageNamed:@"timg.jpeg"];
        self.hearderIMG.layer.cornerRadius = IMG_height / 2;
        self.hearderIMG.layer.masksToBounds = YES;
        
        self.layer.cornerRadius = 15;
    }
    return self;
}

- (void)startAnimation {
    
    // 根据弹幕的长度执行动画效果
    // 根据 速度 = 宽度 / 时间
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat time = 4.0f;
    CGFloat totalWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //开始状态回调
    if (self.movingBlock) {
        self.movingBlock(start);
    }
    
    //时间 = 宽度 / 速度
    CGFloat speed = totalWidth / time;
    CGFloat enterTime = CGRectGetWidth(self.bounds)/speed + 0.15;
    //通过时间计算出弹幕完全进入屏幕的状态
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterTime];
    
    
    // 通过动画改变X 实现自动滚动
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        frame.origin.x -= totalWidth;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        //完全离开屏幕回调
        if (self.movingBlock) {
            self.movingBlock(end);
        }
    }];
    
}
- (void)enterScreen {
    
    //完全进入屏幕回调
    if (self.movingBlock) {
        self.movingBlock(enter);
    }
}

- (void)stopAnimation {
    
    //移除延时执行的方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.layer removeAllAnimations];
//    [self removeFromSuperview];
    
}

-(void)setContent:(NSString *)content{
    //根据字符串设置具体宽度
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGFloat width = [content sizeWithAttributes:attr].width;
    self.frame = CGRectMake(0, 0, width + IMG_height + margin * 2, 30);
    self.lbContent.frame = CGRectMake(IMG_height + 5, 0, width, 30);
    self.lbContent.text = content;
}

-(UILabel *)lbContent
{
    if (!_lbContent) {
        
        _lbContent = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbContent.textColor = [UIColor whiteColor];
        _lbContent.font = [UIFont systemFontOfSize:15];
        _lbContent.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbContent];
    }
    return _lbContent;
}
-(UIImageView *)hearderIMG
{
    if (!_hearderIMG) {
        
        _hearderIMG = [[UIImageView alloc]initWithFrame:CGRectZero];
        _hearderIMG.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_hearderIMG];
        
    }
    return _hearderIMG;
}
@end
