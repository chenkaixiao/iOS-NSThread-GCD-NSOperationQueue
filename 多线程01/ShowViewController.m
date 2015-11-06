//
//  ShowViewController.m
//  多线程01
//
//  Created by zero on 15/3/24.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "ShowViewController.h"

@interface ShowViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@end

@implementation ShowViewController


#pragma mark - 响应按钮事件
- (IBAction)downLoadBtn:(id)sender {
    
    [self downLoadPics];
    
}
#pragma mark - 利用队列组下载图片
-(void)downLoadPics
{
    // 避免循环引用
     typeof(self) MySelf = self;
    
    // 1 创建组
    dispatch_group_t group = dispatch_group_create();
    __block UIImage *image1 = nil;
    __block UIImage *image2 = nil;
    
    // 2 在全局的队列中执行
    //  任务一
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image1 = [MySelf setImageWithUrl:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2983842115,266875619&fm=116&gp=0.jpg"];
        
        
        
        
    });
    // 任务二
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image2 = [MySelf setImageWithUrl:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=640146448,3059473960&fm=116&gp=0.jpg"];
        
    });
    
    // 3 返回主线程设置图片
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MySelf.imageView1 setImage:image1];
        [MySelf.imageView2 setImage:image2];
        
        // 开始画
        UIGraphicsBeginImageContext(KXSize(300, 150));
        
        [image1 drawInRect:KXRect(0, 0, 150, 150)];
        [image2 drawInRect:KXRect(150, 0, 150, 150)];
        // 设置imageView3图片
        [MySelf.imageView3 setImage:UIGraphicsGetImageFromCurrentImageContext()];
        
        // 结束画
        
        UIGraphicsEndImageContext();
    
    });
    
    
}
#pragma mark - 封装下载图片的方法
-(UIImage*)setImageWithUrl:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:imageData];
}

//-(void)dealloc
//{
//    NSLog(@"----dealloc");
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




@end
