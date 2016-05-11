//
//  ViewController.m
//  YQPhotoBrowser
//
//  Created by 尹永奇 on 16/3/30.
//  Copyright © 2016年 yyqxiaoyin. All rights reserved.
//

#import "ViewController.h"
#import "YQImageListView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [YQImageListView showImageListViewInView:self.view
                                  imageWidth:80
                                 imageHeight:80
                                 imageMargin:5
                                  startPoint:CGPointMake(40, 40)];
    
}


@end
