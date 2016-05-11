//
//  YQImageListView.h
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YQImageListView : UIView

/**
 *  类方法显示图片列表
 *
 *  @param view        显示到哪个视图上
 *  @param imageWidth  每个小图的宽度
 *  @param imageHeight 每个小图的高度
 *  @param imageMargin 小图之间的间距
 *  @param startPoint  在父视图上的坐标
 */
+(void)showImageListViewInView:(UIView *)view imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight imageMargin:(CGFloat)imageMargin startPoint:(CGPoint)startPoint;

@end
