//
//  YQPhoto.h
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YQPhoto : UIImageView

/**
 *  小图（原始的imageview）
 */
@property (nonatomic ,strong)UIImageView *smallImageView;
/**
 *  大图的地址
 */
@property (nonatomic ,strong)NSString *bigImageURL;

@end
