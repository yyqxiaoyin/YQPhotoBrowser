//
//  YQImageListView.m
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import "YQImageListView.h"
#import "YQPhoto.h"
#import "YQPhotoBrowser.h"

#define kStatusImageWidth 80
#define kStatusImageHeight 80
#define kStatusImageMargin 5

@interface YQImageListView ()

@property (nonatomic ,strong)NSMutableArray *imageViews;

/**
 *  图片地址数组
 */
@property (nonatomic ,strong)NSMutableArray *bigImageURLs;

@end

@implementation YQImageListView

-(NSMutableArray *)imageViews{

    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    
    return _imageViews;
    
}
-(NSMutableArray *)bigImageURLs{
    
    if (!_bigImageURLs) {
        
        NSArray *tempUrls = @[@"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",
                              @"http://v1.qzone.cc/pic/201303/18/16/55/5146d688ab554456.jpg!600x600.jpg",];
        
        _bigImageURLs = [NSMutableArray arrayWithArray:tempUrls];
        
    }
    
    return _bigImageURLs;
    
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        
        [self setUpViews];
        
    }

    return self;
}

#pragma mark - 初始化子视图
-(void)setUpViews{

    self.backgroundColor = [UIColor lightGrayColor];
    
    for (NSInteger i = 0; i<9; i++) {
        
        
        
//        1.创建小的imageview
        UIImageView *childImageView = [[UIImageView alloc]init];
        childImageView.userInteractionEnabled = YES;
        childImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu.jpg",i+1]];
        childImageView.clipsToBounds = YES;
        childImageView.contentMode = UIViewContentModeScaleAspectFill;
        childImageView.tag = i;
        
//        2.添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        [childImageView addGestureRecognizer:tap];
        
//        3.设置frame
        int column = i%3;//imageview在第几列
        int row =  floor(i/3);//imageview在第几行
        
//        根据imageView在第几行第几列计算出imageview的 x、y
        int childImgX = column *(kStatusImageWidth +kStatusImageMargin);
        int childImgY = row * (kStatusImageHeight +kStatusImageMargin);
        
        childImageView.frame = CGRectMake(childImgX, childImgY, kStatusImageWidth, kStatusImageHeight);
        
        [self addSubview:childImageView];
        
        [self.imageViews addObject:childImageView];
        
        
    }
    
    
}

+(void)showImageListViewInView:(UIView *)view imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight imageMargin:(CGFloat)imageMargin startPoint:(CGPoint)startPoint{

    YQImageListView *list = [[YQImageListView alloc]initWithFrame:CGRectMake(startPoint.x, startPoint.y, kStatusImageWidth *3 +(kStatusImageMargin *2), kStatusImageHeight *3 +(kStatusImageMargin *2))];
    
    [view addSubview:list];

}

#pragma mark 图片点击

-(void)imageClick:(UITapGestureRecognizer *)tap{
    

    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSInteger i = 0; i<self.imageViews.count; i++) {
        
        UIImageView *child = self.imageViews[i];
        YQPhoto *photo = [[YQPhoto alloc]init];
        photo.smallImageView = child;
        
        photo.bigImageURL = self.bigImageURLs[i];
        photo.tag = i;
        [photos addObject:photo];
        
    }
    
    YQPhotoBrowser *photoBrowser = [[YQPhotoBrowser alloc]init];
    photoBrowser.photos = photos;
    photoBrowser.currentIndex = tap.view.tag;
    [photoBrowser show];
}

@end
