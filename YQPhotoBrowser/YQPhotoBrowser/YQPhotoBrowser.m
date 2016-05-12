//
//  YQPhotoBrowser.m
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import "YQPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import "YQProgressView.h"
#import <LK_THProgressView.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define KKeyWindow [UIApplication sharedApplication].keyWindow

#define BaseScrollVIewTag 101

@interface YQPhotoBrowser ()<UIScrollViewDelegate>

/**
 *  最底层的scrollview
 */
@property (nonatomic ,strong)UIScrollView *baseScrollView;

/**
 *  黑色背景的view
 */
@property (nonatomic ,strong)UIView * blackView;
/**
 *  原始frame数组
 */
@property (nonatomic,strong) NSMutableArray *originRects;


@end

@implementation YQPhotoBrowser
-(NSMutableArray *)originRects{
    
    if (_originRects==nil) {
        
        _originRects = [NSMutableArray array];
        
    }
    
    return _originRects;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        //1.创建bigScrollView
        [self setupBigScrollView];
        
    }
    return self;
}

#pragma mark - 创建最底层的scrollview
-(void)setupBigScrollView{


    self.baseScrollView = [[UIScrollView alloc] init];
    self.baseScrollView.backgroundColor = [UIColor blackColor];
    self.baseScrollView.delegate = self;
    self.baseScrollView.tag = BaseScrollVIewTag;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.bounces = YES;
    self.baseScrollView.showsHorizontalScrollIndicator = YES;
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = ScreenWidth;
    CGFloat scrollViewH = ScreenHeight;
    self.baseScrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    [self addSubview:self.baseScrollView];

    
}


-(void)show{

    [self setupOriginRects];
    
//    设置最底层scrollview的contentSize
    self.baseScrollView.contentSize = CGSizeMake(ScreenWidth*self.photos.count, 0);
    self.baseScrollView.contentOffset = CGPointMake(ScreenWidth *self.currentIndex, 0);
    
    [self setUpSmallScrollViews];

    [KKeyWindow addSubview:self];


}

#pragma mark - 创建图片对应的scrollview
-(void)setUpSmallScrollViews{
    
    
//    每个图片都添加到一个单独的scrollview里边，根据图片个数创建scrollview
    for (NSInteger i = 0; i<self.photos.count; i++) {
        
        UIScrollView *sc = [[UIScrollView alloc]init];
        sc.tag = i;
        sc.delegate = self;
        sc.maximumZoomScale=3.0;
        sc.minimumZoomScale=1;
        sc.backgroundColor = [UIColor clearColor];
        
        sc.frame = CGRectMake(ScreenWidth *i, 0, ScreenWidth, ScreenHeight);
        
        [self.baseScrollView addSubview:sc];
        
//        取出数组里边的图片模型
        YQPhoto *photo = self.photos[i];

        [photo sd_setImageWithURL:[NSURL URLWithString:photo.bigImageURL] placeholderImage:photo.smallImageView.image options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            //如果图片还没有缓存。先把之前的小图放到中间
            photo.frame = CGRectMake(0, 0, photo.frame.size.width, photo.frame.size.height);
            photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            
            if (photo.tag == self.currentIndex) {//判断进来的那张图片
                
                if (expectedSize!=-1) {
                    YQProgressView *progressView = [YQProgressView showHMProgressView:self viewHeight:80];
                    [progressView setProgress:(CGFloat)receivedSize/expectedSize];
                }
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
            if (image!=nil) {
                
                photo.frame = [self.originRects[i] CGRectValue];
                
                if (cacheType==SDImageCacheTypeNone) {
                    
                    photo.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/2);
                    photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                    
                }
            }
            //图片缓存成功之后。放大图片
            [UIView animateWithDuration:0.3 animations:^{
                
                
                CGFloat ratio = (double)photo.image.size.height/(double)photo.image.size.width;
                
                CGFloat bigW = ScreenWidth;
                CGFloat bigH = ScreenWidth*ratio;
                
                photo.bounds = CGRectMake(0, 0, bigW, bigH);
                photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                
                
            }];
            
        }];


//        给图片添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoClick:)];
        [photo addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [photo addGestureRecognizer:doubleTapGestureRecognizer];
        [tap requireGestureRecognizerToFail:doubleTapGestureRecognizer];//单双击共存

        [sc addSubview:photo];
        
    }
    


}


#pragma mark 图片双击
-(void)doubleTap:(UITapGestureRecognizer *)sender{
    
    YQPhoto *photo = (YQPhoto *)self.photos[sender.view.tag];
    UIScrollView *sc = (UIScrollView *)photo.superview;
    float zoomScale = sc.zoomScale;
    zoomScale = zoomScale *1.5;
    [sc setZoomScale:zoomScale animated:YES];
    
}


#pragma  mark 图片点击
-(void)photoClick:(UITapGestureRecognizer *)sender{

    //获取点击的图片
    YQPhoto *photo = (YQPhoto *)sender.view;
    
    //如果图片已经缩放过。先让图片回复原装
    UIScrollView *sc = (UIScrollView *)photo.superview;
    
    if (sc.zoomScale != 1.0) {
        
        [sc setZoomScale:1.0 animated:YES];
        
    }else{
        //通过图片的tag取出点击的图片的frame
        CGRect frame = [self.originRects[photo.tag] CGRectValue];
        
        [UIView animateWithDuration:.3f animations:^{
            
            photo.frame = frame;
            
            
        } completion:^(BOOL finished) {
            self.alpha = 0;
            [self removeFromSuperview];
            
        }];
    }

}

#pragma mark 获取原始frame
-(void)setupOriginRects{
    
    for (YQPhoto *photo in self.photos) {
        
        UIImageView *sourceImageView = photo.smallImageView;
        CGRect sourceFrame = [KKeyWindow convertRect:sourceImageView.frame fromView:sourceImageView.superview];
        [self.originRects addObject:[NSValue valueWithCGRect:sourceFrame]];
        
    }
    
}

#pragma mark - 滚动视图的代理

#pragma mark scrollview缩放
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    if (scrollView.tag == BaseScrollVIewTag) {//禁用掉最底层scrollview的缩放操作
        
        return nil;
        
    }
    
    //取出要缩放的图片
    YQPhoto *photo = self.photos[scrollView.tag];
    
    return photo;
    
}
#pragma mark 正在进行缩放操作
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if (scrollView.tag==BaseScrollVIewTag) {
        return;
    }
    
    //缩放时调整图片的位置始终位于屏幕中央
    YQPhoto *photo = (YQPhoto *)self.photos[scrollView.tag];
    
    CGFloat photoY = (ScreenHeight-photo.frame.size.height)/2;
    CGRect photoFrame = photo.frame;
    
    if (photoY>0) {
        
        photoFrame.origin.y = photoY;
        
    }else{
        
        photoFrame.origin.y = 0;
        
    }
    
    photo.frame = photoFrame;
    
    
}

//滑动到另一页的时候。设置self.currentIndex跟活肤所有小scrollview的zoom
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == BaseScrollVIewTag) {
    
    int currentIndex = scrollView.contentOffset.x/ScreenWidth;

    if (self.currentIndex!=currentIndex) {
        
        self.currentIndex = currentIndex;
        
        for (UIView *view in scrollView.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                UIScrollView *scrollView = (UIScrollView *)view;
                scrollView.zoomScale = 1.0;
            }
            
        }
        
    }
 }

}


@end
