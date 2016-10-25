//
//  ViewController.m
//  测试-01-动画
//
//  Created by 刘凡 on 2016/9/22.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "HMCircleAnimator.h"

@interface ViewController ()

@end

@implementation ViewController {
    HMCircleAnimator *_circleAnimator;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // 1. 设置展现样式为自定义
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        // 2. 设置转场动画代理，需要使用一个强引用的成员变量记录
        _circleAnimator = [HMCircleAnimator new];
        self.transitioningDelegate = _circleAnimator;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 测试动画效果
 */
- (void)demoAnim {

    // 1. 实例化图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 2. 设置图层属性
    // 路径
    CGFloat radius = 50;
    CGFloat margin = 20;
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    
    // 初始位置
    CGRect rect = CGRectMake(viewWidth - radius - margin, margin, radius, radius);
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    layer.path = beginPath.CGPath;
    
    // 计算对角线 勾股定理
    CGFloat maxRadius = sqrt(viewWidth * viewWidth + viewHeight * viewHeight);
    
    // 结束位置 - 利用缩进，参数为负，是放大矩形，中心点保持不变
    CGRect endRect = CGRectInset(rect, -maxRadius, -maxRadius);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
//    layer.path = endPath.CGPath;
    
    // 3. 将图层添加到 view 的图层，当作子图层
    // [self.view.layer addSublayer:layer];
    // 4. 设置图层的遮罩 - 会裁切视图，视图本质上没有发生任何的变化，但是只会显示路径包含范围内的内容
    // 提示：一旦设置为 mask 属性，填充颜色无效！
    self.view.layer.mask = layer;
    
    // 5. 动画 - 如果要做 shapeLayer 的动画，不能使用 UIView 的动画方法，应该用核心动画
//    [UIView animateWithDuration:3 animations:^{
//        layer.path = endPath.CGPath;
//    }];
    
    // 1> 实例化动画对象
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    // 2> 设置动画属性 - 时长／fromValue / toValue
    anim.duration = 3;
    anim.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    anim.toValue = (__bridge id _Nullable)(endPath.CGPath);

    // 设置向前填充模式
    anim.fillMode = kCAFillModeForwards;

    // 完成之后不删除
    anim.removedOnCompletion = NO;
    
    // 3> 将动画添加到图层 - ShaperLayer，让哪个图层动画，就应该将动画添加到哪个图层
    [layer addAnimation:anim forKey:nil];
}

- (void)demoLayer {
    // 1. 实例化图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 2. 设置图层属性
    // 路径
    CGFloat radius = 50;
    CGFloat margin = 20;
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    
    // 初始位置
    CGRect rect = CGRectMake(viewWidth - radius - margin, margin, radius, radius);
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    layer.path = beginPath.CGPath;
    
    // 计算对角线 勾股定理
    CGFloat maxRadius = sqrt(viewWidth * viewWidth + viewHeight * viewHeight);
    
    // 结束位置 - 利用缩进，参数为负，是放大矩形，中心点保持不变
    CGRect endRect = CGRectInset(rect, -maxRadius, -maxRadius);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    layer.path = endPath.CGPath;
    
    // 3. 将图层添加到 view 的图层，当作子图层
    // [self.view.layer addSublayer:layer];
    // 4. 设置图层的遮罩 - 会裁切视图，视图本质上没有发生任何的变化，但是只会显示路径包含范围内的内容
    // 提示：一旦设置为 mask 属性，填充颜色无效！
    self.view.layer.mask = layer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
