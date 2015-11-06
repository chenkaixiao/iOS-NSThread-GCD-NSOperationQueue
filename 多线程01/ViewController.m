//
//  ViewController.m
//  多线程01
//
//  Created by zero on 15/3/23.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "KXAudioTool.h"

@interface ViewController ()
@property(nonatomic,assign)int leftTicksCounts;
@property(nonatomic,strong)NSThread *currTh1;
@property(nonatomic,strong)NSThread *currTh2;
@property(nonatomic,strong)NSThread *currTh3;
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;

@end

@implementation ViewController
- (IBAction)btn:(id)sender {
    
    // -1 简单线程查看代码
//    [self getCurrThread];
    
    // -2 NShtread线程的创建
//    [self createThread1];
//    [self createThread2];
       [self createThread3];
    

    
}


#pragma mark - NSThtread创建与启动
-(void)createThread1
{
    NSThread *cur1 = [[NSThread alloc]initWithTarget:self selector:@selector(excute:) object:@"创建线程"];
    [cur1 start];
}
-(void)excute:(NSString*)str
{
    NSLog(@"创建线:%@",str);
}

// 自动启动
-(void)createThread2
{
    [NSThread detachNewThreadSelector:@selector(excute:) toTarget:self withObject:@"自动启动线程"];
}
// 后台执行 并且自动启动
-(void)createThread3
{
    [self performSelectorInBackground:@selector(excute:) withObject:@"隐式创建"];
}

#pragma mark - 简单线程查看
-(void)getCurrThread
{
    // 1 获取当前的线程
    NSThread *curr = [NSThread currentThread];
    
    
    // 是否是子线程
    if([curr isMainThread])
        NSLog(@"YES-----");
    // 是否是多线程
    if([NSThread isMultiThreaded])
        NSLog(@"YES-------");

    // 2 使用for循环执行一些耗时的错左
    for (int i = 0; i < 1000; i++) {
        NSLog(@"btnClick --- %d --- %@",i,curr);
    }

    NSLog(@"-----mainThread:%@",[NSThread mainThread]);
}

- (IBAction)btnSafe:(id)sender {
    
    // 1 默认有20张票
    self.leftTicksCounts = 20;
    
    // 开启多个线程模拟售票员售票
    self.currTh1 = [[NSThread alloc]initWithTarget:self selector:@selector(sellTicks) object:nil];
    [self.currTh1 setName:@"售票员A"];
    
    self.currTh2 = [[NSThread alloc]initWithTarget:self selector:@selector(sellTicks) object:nil];
    [self.currTh2 setName:@"售票员B"];
    
    self.currTh3 = [[NSThread alloc]initWithTarget:self selector:@selector(sellTicks) object:nil];
    [self.currTh3 setName:@"售票员C"];
    
    [self.currTh1 start];
    [self.currTh2 start];
    [self.currTh3 start];
    
}

-(void)sellTicks
{
    while (1) {
        
        
        // 加锁 （一份代码只能一把锁 多把锁是无效的）
        @synchronized(self)
        {
            // 1检查票数
            int count  = self.leftTicksCounts;
            if(count > 0)
            {
                // 暂停一段时间
                [NSThread sleepForTimeInterval:2];
                
               // 2 票数 －1
                self.leftTicksCounts = count - 1;
                
                // 获取当前的线程
                NSLog(@"%@ ---卖了一张票，还剩余 %d",[NSThread currentThread],self.leftTicksCounts);
            }
            else
            {
                //  退出线程
                [NSThread exit];
            }
        }
    }
    
}


#pragma mark - 线程通信
- (IBAction)btTongxin:(id)sender {
    
    [self performSelectorInBackground:@selector(downLoad) withObject:self];
}


// 后台线程下载图片
-(void)downLoad
{
    // 1 NSURL
       NSString *urlStr = @"https://www.baidu.com/img/bd_logo1.png";
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2 data
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 3 image
    UIImage *image = [UIImage imageWithData:data];
    
    // 4 返回主线程设置图片
    [self performSelectorOnMainThread:@selector(setImageForView:) withObject:image waitUntilDone:NO];
    
    
    
}
-(void)setImageForView:(UIImage*)image
{
    [self.imgeView setImage:image];
}

#pragma mark - GCD 学习
/*
 *  队列（queue） 任务（block） 
 *  异步   同步
 */
- (IBAction)GCDbtn:(id)sender {
    
    //用异步函数往 并发队列中添加任
//    [self creat3BAThread];
    
    //用异步函数往 串行队列中添加任务
    [self creat3CAThread];
}
// 同时开启了 3 个线程
-(void)creat3BAThread
{
    // 1  获取全局并发队列  // 优先级  0 无作用
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2  同时创建3个线程执行任务
    dispatch_async(queue, ^{
        NSLog(@"假设下载1－－－－%@",[NSThread currentThread]);
        
    });
    dispatch_async(queue, ^{
        NSLog(@"假设下载2－－－－%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"假设下载3－－－－%@",[NSThread currentThread]);
    });
    
    NSLog(@"主线程－－－－－ %@",[NSThread currentThread]);
}
-(void)creat3CAThread
{
    dispatch_queue_t queue = dispatch_queue_create("CKX", NULL);
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    // 2  同时创建3个线程执行任务
    dispatch_async(queue, ^{
        NSLog(@"假设下载1－－－－%@",[NSThread currentThread]);
        
    });
    dispatch_async(queue, ^{
        NSLog(@"假设下载2－－－－%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"假设下载3－－－－%@",[NSThread currentThread]);
    });
    
    NSLog(@"主线程－－－－－ %@",[NSThread currentThread]);
    //3.释放资源 MRC
     //   dispatch_release(queue);
}
#pragma mark - NSOperation

- (IBAction)BtnOperation:(id)sender {
    
    // 1 NSInvocationOperation
//    [self StartNSInvocationOperation];
    
    // 2 NSOperationBlock
    [self StartNSBlockOperation];
    
    
}
-(void)StartNSBlockOperation
{
    
    // 1 创建任务
    NSBlockOperation *blockOper1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"--->blockOper1");
    }];
    
   
    NSBlockOperation *blockOper2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"--->blockOper2");
    }];
    NSBlockOperation *blockOper3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"--->blockOper3");
    }];
    
    // 2 监听是否完成
    blockOper1.completionBlock = ^{
        NSLog(@"blockOper1---->finishde");
    };
    blockOper2.completionBlock = ^{
        NSLog(@"blockOper2---->finishde");
    };
    
    blockOper3.completionBlock = ^{
        NSLog(@"blockOper3---->finishde");
    };
    
    // 3 加入队列中
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:blockOper1];
    [queue addOperation:blockOper2];
    [queue addOperation:blockOper3];
}
-(void)StartNSInvocationOperation
{
    // 创建operation操作
    NSInvocationOperation *inOperation1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(test1:) object:@"--->NSInvocationOperation1"];
   
    
    NSInvocationOperation *inOperation2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(test1:) object:@"NSInvocationOperation2"];
    NSInvocationOperation *inOperation3 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(test1:) object:@"NSInvocationOperation3"];
    
    // 线程之间的依赖(注意要在加入队列的前面)
    [inOperation1 addDependency:inOperation2];
    [inOperation2 addDependency:inOperation3];
    // 队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:inOperation1];
    [queue addOperation:inOperation2];
    [queue addOperation:inOperation3];
}
// 方式一 NSInvocationOperation
-(void)test1:(NSString*)str
{
    NSLog(@"--->test:%@",str);
}


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    KXAudioTool *audioTool1 = [[KXAudioTool alloc]init];
//    KXAudioTool *audioTool2 = [[KXAudioTool alloc]init];
//    KXAudioTool *audioTool3 = [[KXAudioTool alloc]init];
//    
//    NSLog(@"单例模式：----%p ------ %p ------ %p ",audioTool1,audioTool2,audioTool3);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
