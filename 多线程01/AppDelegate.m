//
//  AppDelegate.m
//  多线程01
//
//  Created by zero on 15/3/23.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    int tickets;
    int count;
    NSThread *ticketOne;
    NSThread *ticketTwo;
    
    NSLock *ticketLock; // 线程锁
    NSCondition *ticketCondition;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    tickets = 100;
    count = 0;
    
    ticketLock = [[NSLock alloc]init];
    ticketCondition = [[NSCondition alloc]init];
    
    // 创建线程 1
    ticketOne = [[NSThread alloc]initWithTarget:self selector:@selector(runThread) object:nil];
    [ticketOne setName:@"Thread-1"];
//    [ticketOne start];
    
    // 创建线程 2
    ticketTwo = [[NSThread alloc]initWithTarget:self selector:@selector(runThread) object:nil];
    [ticketTwo setName:@"Thread-2"];
//    [ticketTwo start];
    
      // 申请执行代码多少遍
//    dispatch_apply(5, dispatch_get_global_queue(0, 0), ^(size_t index) {
//       
//        NSLog(@"--%s--%d",__FUNCTION__,__LINE__);
//        
//    });
    
      // dispatch_barrier_async的使用
//    dispatch_queue_t queue = dispatch_queue_create("队列1",  DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_async(queue, ^{
////        [NSThread sleepForTimeInterval:2.0];
//        NSLog(@"dispatch_1");
//    });
//    
//    dispatch_async(queue, ^{
////        [NSThread sleepForTimeInterval:3.0];
//        NSLog(@"dispatch_2");
//    });
//    
//    dispatch_barrier_async(queue, ^{
//        
////        [NSThread sleepForTimeInterval:5.0];
//        NSLog(@"dispatch_barrier");
//        
//        
//    });
//    
//    
//    
//    dispatch_async(queue, ^{
////        [NSThread sleepForTimeInterval:1.0];
//        NSLog(@"dispatch_3");
//    });
    
    // Group的使用 dispatch_group_async
    
//    // 创建队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    // 创建group
//    dispatch_group_t group = dispatch_group_create();
//    
//    // 执行任务一
//    dispatch_group_async(group, queue, ^{
//        [NSThread sleepForTimeInterval:4.0];
//        NSLog(@"任务一");
//    });
//    
//    // 执行任务二
//    dispatch_group_async(group, queue, ^{
//       [NSThread sleepForTimeInterval:8.0];
//        NSLog(@"任务二");
//    });
//    
//    
//    // 执行完任务一、二,通知任务三
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"任务三");
//    });
//    
    
    
    
    return YES;
}

-(void)runThread
{
    while (true) {
        
        // 上锁
//        [ticketLock lock];
        [ticketCondition lock];
        if(tickets >=0)
        {
            [NSThread sleepForTimeInterval:0.09];
            count = 100 - tickets;
            NSLog(@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
            tickets--;
        }else
        {
            break;
        }
        [ticketCondition unlock];
//        [ticketLock unlock];
        
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
