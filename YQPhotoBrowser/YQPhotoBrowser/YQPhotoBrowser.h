//
//  YQPhotoBrowser.h
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQPhoto.h"

@interface YQPhotoBrowser : UIView

/**
 *  存放YQPhoto的数组
 */
@property (nonatomic ,strong)NSArray *photos;

/**
 *  当前的index
 */
@property (nonatomic ,assign)NSInteger currentIndex;


/**
 *  显示
 */
-(void)show;

@end
