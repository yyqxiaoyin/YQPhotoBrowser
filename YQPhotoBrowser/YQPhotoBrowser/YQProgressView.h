//
//  YQProgressView.h
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQProgressView : UIView

+(YQProgressView *)showHMProgressView:(UIView *)parentView viewHeight:(CGFloat)viewHeight;

@property (nonatomic ,assign)CGFloat progress;

@end
