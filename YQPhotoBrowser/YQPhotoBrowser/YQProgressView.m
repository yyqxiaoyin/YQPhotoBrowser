//
//  YQProgressView.m
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import "YQProgressView.h"
#define KKeyWindow  [UIApplication sharedApplication].keyWindow
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface YQProgressView ()



@end

@implementation YQProgressView

+(YQProgressView *)showHMProgressView:(UIView *)parentView viewHeight:(CGFloat)viewHeight{

    YQProgressView *progressView=(YQProgressView *)[parentView viewWithTag:999];
    if (!progressView) {
        progressView=[[YQProgressView alloc] initWithFrame:CGRectMake(0, 0, viewHeight, viewHeight)];
        progressView.tag=999;
        progressView.center=parentView.center;
        progressView.backgroundColor=[UIColor clearColor];
        [parentView addSubview:progressView];
    }
    return progressView;
}
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    // 重新绘制
    [self setNeedsDisplay];
    if (_progress==1) {//加载完成时移除
        [self removeFromSuperview];
    }
    
}


// 当视图显示的时候会调用 默认只会调用一次
- (void)drawRect:(CGRect)rect
{
    
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.拼接路径
    CGPoint center = CGPointMake(25, 25);
    CGFloat radius = 25 - 2;
    CGFloat startA = -M_PI_2;
    CGFloat endA = -M_PI_2 + _progress * M_PI * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    [[UIColor whiteColor]set];
    CGContextSetLineWidth(ctx, 8);
    // 3.把路径添加到上下文
    [[UIColor lightGrayColor] set];
    CGContextAddPath(ctx, path.CGPath);
    
    // 4.把上下文渲染到视图
    CGContextStrokePath(ctx);
    
}
@end
