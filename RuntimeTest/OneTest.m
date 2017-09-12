//
//  OneTest.m
//  RuntimeTest
//
//  Created by chang on 2016/9/7.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "OneTest.h"
#import <objc/runtime.h>

@implementation OneTest

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [aCoder encodeObject:_nameStr forKey:@"nameStr"];
//    [aCoder encodeObject:_sexStr forKey:@"sexStr"];
//    [aCoder encodeInt:_age forKey:@"age"];
    
    
    
    /******   通过runtime获取成员变量 来for循环进行归档   ******/
    unsigned int count = 0;
    //获取类成员变量列表，返回类的所有属性和变量
    Ivar *ivars = class_copyIvarList([OneTest class], &count);
    //第一个参数填写类，第二个参数count为类成员数量
    
    for (int i=0; i<count; i++) {
        
        //通过指针取数据
        Ivar ivar = ivars[i];
        
        //获取数据name，返回C的字符串
        const char *name = ivar_getName(ivar);
        
        //转换成OC字符串（这里获取到成员变量的name）
        NSString *key = [NSString stringWithUTF8String:name];
        
        //通过KVC获取成员变量的值
        id value = [self valueForKey:key];
        
        //归档
        [aCoder encodeObject:value forKey:key];
    }
    //在C语言里面，看到New Creat Copy等都需要释放
    free(ivars);
}


//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
//        _nameStr = [aDecoder decodeObjectForKey:@"nameStr"];
//        _sexStr = [aDecoder decodeObjectForKey:@"sexStr"];
//        _age = [aDecoder decodeIntForKey:@"age"];
        
        /******   通过runtime获取成员变量 来for循环进行解档   ******/
        unsigned int count = 0;
        //获取类成员变量列表
        Ivar *ivars = class_copyIvarList([OneTest class], &count);//返回类的所有属性和变量
        //第一个参数填写类，第二个参数count为类成员数量
        
        for (int i=0; i<count; i++) {
            
            //通过指针取数据
            Ivar ivar = ivars[i];
            
            //获取数据name，返回C的字符串
            const char *name = ivar_getName(ivar);
            
            //转换成OC字符串（这里获取到成员变量的name）
            NSString *key = [NSString stringWithUTF8String:name];
            
            //解档
            id value = [aDecoder decodeObjectForKey:key];
            
            //通过KVC来赋值
            [self setValue:value forKey:key];
        }
        //在C语言里面，看到New Creat Copy等都需要释放
        free(ivars);
        
    }
    return self;
}






@end
