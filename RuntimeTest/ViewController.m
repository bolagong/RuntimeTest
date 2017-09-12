//
//  ViewController.m
//  RuntimeTest
//
//  Created by chang on 2016/9/7.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "ViewController.h"
#import "OneTest.h"
#import "NSURL+CNSURL.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //test one
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(50, 50, 120, 40);
    saveBtn.backgroundColor = [UIColor orangeColor];
    [saveBtn setTitle:@"归档(存储)" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveGD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
    UIButton *takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeBtn.frame = CGRectMake(50, 120, 120, 40);
    takeBtn.backgroundColor = [UIColor orangeColor];
    [takeBtn setTitle:@"解档(取出)" forState:UIControlStateNormal];
    [takeBtn addTarget:self action:@selector(takeJD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeBtn];
    
    
    
    //test two
    
    UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noBtn.frame = CGRectMake(50, 190, 210, 40);
    noBtn.backgroundColor = [UIColor orangeColor];
    [noBtn setTitle:@"点击一个没有文字的URL" forState:UIControlStateNormal];
    [noBtn addTarget:self action:@selector(isNoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noBtn];
    
    UIButton *yeaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yeaBtn.frame = CGRectMake(50, 260, 210, 40);
    yeaBtn.backgroundColor = [UIColor orangeColor];
    [yeaBtn setTitle:@"点击一个有文字的URL" forState:UIControlStateNormal];
    [yeaBtn addTarget:self action:@selector(isYEAAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yeaBtn];
}

// 归档
- (void)saveGD:(UIButton *)sender{
    
    //在这里我们模拟数据归档
    OneTest *oneTest = [[OneTest alloc] init];
    oneTest.nameStr = @"浮生若梦";
    oneTest.sexStr = @"男";
    oneTest.age = 18;
    
    //设置一个保存路径
    //获取Document文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSLog(@"path====:%@",documentPath);
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"chang"];
    
    //归档
    [NSKeyedArchiver archiveRootObject:oneTest toFile:filePath];
    
}

//解档
- (void)takeJD:(UIButton *)sender{
    
    //获取Document文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSLog(@"path====:%@",documentPath);
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"chang"];
    
    //解档
    OneTest *oneTest = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    NSLog(@"名字==%@,性别==%@,年龄==%d",oneTest.nameStr,oneTest.sexStr,oneTest.age);
    
}



//点击一个没有文字的URL
- (void)isNoAction:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSLog(@"不包含文字url===[111]===%@",url);
}
//点击一个有文字的URL
- (void)isYEAAction:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"https://baike.baidu.com/item/浮生若梦/42165?fr=aladdin"];
    NSLog(@"包含文字进行编码url===[111]===%@",url);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
