//
//  NSURL+CNSURL.m
//  RuntimeTest
//
//  Created by chang on 2017/9/8.
//  Copyright © 2017年 chang. All rights reserved.
//

#import "NSURL+CNSURL.h"
#import <objc/runtime.h>

@implementation NSURL (CNSURL)


//整个项目调用的都是系统的URLWithStr方法，所以在运行的时候Hook住系统的方法，修改成为自己的方法。
+ (void)load
{
    //Method method =  class_getClassMethod(类, 方法名); //这个函数用来获取类方法
    //Method method = class_getInstanceMethod(类, 方法名);//这个函数用来获取实例方法
    
    //拿到OC的方法
    Method url_method = class_getClassMethod([NSURL class], @selector(URLWithString:));
    //拿到自己写的方法
    Method ch_method = class_getClassMethod([NSURL class], @selector(CHURLWithString:));
    //将两个方法交换实现
    method_exchangeImplementations(url_method, ch_method);
}




/***
 这里只判断是否包含汉字
 根据汉字的编码位置判断，几乎所有汉字的 UNICODE 编码范围是4e00-9fff。
 因为区间范围有多处，这里只判断一处最大的范围（几万字），其余几个范围少（一共才几百字）。
 ***/
+ (BOOL)isContainChinese:(NSString *)str
{
    for (int i=0; i<str.length; i++) {
        
        int num = [str characterAtIndex:i];
        
        if( num >0x4e00 && num < 0x9fff) {
            
            NSLog(@"===这个str包含文字===");
            return YES;
        }
    }
    NSLog(@"===这个str不包含文字===");
    return NO;
}

+ (instancetype)CHURLWithString:(NSString *)urlStr
{
    BOOL isContain = [self isContainChinese:urlStr];
    if (isContain==YES) {
        //如果包含文字,需要进行编码处理
        NSString *cotinURL = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        /***
         这里需要注意：此时如果再调用 [NSURL URLWithString:cotinURL] 会发生递归
         因为我们已经用method_exchangeImplementations函数把方法给调换了，
         此时应该调用 CHURLWithString:
         ***/
        NSURL *url = [NSURL CHURLWithString:cotinURL];//实质上是调用URLWithString:方法的实现
        NSLog(@"包含文字进行编码url===[000]===%@",url);
        
        return url;
    }else{
        NSURL *url = [NSURL CHURLWithString:urlStr];//实质上是调用URLWithString:方法的实现
        NSLog(@"不包含文字url===[000]===%@",url);
        
        return url;
    }
}


@end
