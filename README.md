# Barrage
闲来无事找的弹幕demo[原demo地址](https://github.com/LiuYulei001/BulletView) 感觉存在一些问题而且不可以实时插入新的弹幕， 所以进行了修改
[git地址](https://github.com/2232787525/Barrage)

![Image text](https://github.com/2232787525/Barrage/blob/master/image/弹幕gif.gif)

功能优化如下：

1. 通过设置 BulletManager 中的 numOfLines 属性 设置弹道的行数
2. 弹幕来源通过更改 BulletManager 中的 dataSource设置
3. 实时加入弹幕
4. 在原demo的基础上加了弹幕view的重用

调用弹幕只需要执行以下几个方法
```
//初始化
self.manager = [[BulletManager alloc]init];
self.manager.numOfLines = 10;
__weak typeof(self) weakSelf = self;
self.manager.generrateViewBlock = ^(BulletView *view){

[weakSelf addBarrageView:view];
};

//调用以下方法实现弹幕的实时插入
- (IBAction)addaBarrage:(UIButton *)sender {
[self.manager.dataSource insertObject:[NSString stringWithFormat:@"弹幕 %d", arc4random()%1000] atIndex:0];
[self.manager showNewBullet];
}

//新增一条动画
- (void)addBarrageView:(BulletView *)view {

CGFloat width = [UIScreen mainScreen].bounds.size.width;
view.frame = CGRectMake(width, 150 + view.line * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
[self.view addSubview:view];
[view startAnimation];
}

//取消弹幕
- (IBAction)Stop:(UIButton *)sender {
[self.manager stop];
}

//开始 （被我改成了按钮重置弹幕数量，里面是一些写死的数据）
- (IBAction)start:(UIButton *)sender {
[self.manager start];
}

