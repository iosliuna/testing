//
//  ViewController.m
//  JSDemo
//
//  Created by YongCheHui on 15/6/17.
//  Copyright (c) 2015年 FengHuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIWebView*webView = [[UIWebView alloc]init];
    [webView loadRequest:nil];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *priceFile = [mainBundle pathForResource:@"price" ofType:@"txt"];
    NSData *pData = [NSData dataWithContentsOfFile:priceFile];
    NSString *pStr = [[NSString alloc]initWithData:pData encoding:NSUTF8StringEncoding];
    NSArray *pArray = [pStr componentsSeparatedByString:@"\n"];
    
    NSMutableDictionary *priceInfo = [NSMutableDictionary new];
    [priceInfo setObject:@"Math.ceil" forKey:@"ceil"];
    [priceInfo setObject:@"Math.max" forKey:@"max"];
    [priceInfo setObject:@"Math.min" forKey:@"min"];
    [priceInfo setObject:@"Math.round" forKey:@"round"];
    
    [priceInfo setObject:@"1434432781991l" forKey:@"开始时间"];
    
    [priceInfo setObject:@"1434432781991l" forKey:@"结束时间"];
    [priceInfo setObject:@"0.0" forKey:@"高速费"];
    [priceInfo setObject:@"0.0" forKey:@"停车费"];
    [priceInfo setObject:@"0.0" forKey:@"其他费用"];
    [priceInfo setObject:@"0.0" forKey:@"行驶距离"];
    [priceInfo setObject:@"0.0" forKey:@"超出分钟"];
    [priceInfo setObject:@"15" forKey:@"实际计费公里数"];
    [priceInfo setObject:@"30" forKey:@"系统记录行驶分钟"];
    [priceInfo setObject:@"22" forKey:@"系统记录行驶公里数"];
    [priceInfo setObject:@"0" forKey:@"夜间服务时长"];
    [priceInfo setObject:@"0" forKey:@"订单是否取消"];
    
    for (NSString *line in pArray) {
        NSArray *keyValues = [line componentsSeparatedByString:@"="];
        [priceInfo setObject:keyValues[1] forKey:keyValues[0]];
    }
    
    NSString *expFile = [mainBundle pathForResource:@"exp" ofType:@"txt"];
    NSData *eData = [NSData dataWithContentsOfFile:expFile];
    NSString *eStr = [[NSString alloc]initWithData:eData encoding:NSUTF8StringEncoding];
    NSArray *eArray = [eStr componentsSeparatedByString:@"\n"];
    
    for (NSString *line in eArray) {
        NSArray *keyValues = [line componentsSeparatedByString:@"="];
        NSMutableString *value = [keyValues[1] mutableCopy];
        
        NSArray *allkeys = [priceInfo allKeys];
        allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *s1 = obj1;
            NSString *s2 = obj2;
            return s1.length < s2.length;
        }];
        
        for (NSString* key in allkeys) {
            [value replaceOccurrencesOfString:key withString:priceInfo[key] options:NSCaseInsensitiveSearch range:NSMakeRange(0, value.length)];
        }
        NSString*result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"eval(%@);",value]];
//        if ([result isEqualToString:@""]) {
//            NSLog(@"无法计算的表达式 %@:%@   原表达式:%@",keyValues[0],value,keyValues[1]);
//        }
        [priceInfo setObject:result forKey:keyValues[0]];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
