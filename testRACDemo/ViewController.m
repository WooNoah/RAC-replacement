//
//  ViewController.m
//  testRACDemo
//
//  Created by tb on 16/11/30.
//  Copyright © 2016年 com.tb. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
#import "SecViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    [self testRACCommand];
    
    [self testRacForSelector];
    [self testReplaceNotificationCenter];
    
}

///测试RAC代替通知中心
- (void)testReplaceNotificationCenter {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
     subscribeNext:^(id x) {
         NSLog(@"键盘要出来了");
     }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
     subscribeNext:^(id x) {
         NSLog(@"键盘要消失了");
     }];
}

///测试rac代替代理
- (void)testRacForSelector {
    self.textField.delegate = self;
    
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        NSLog(@"开始编辑");
    }];
    
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]
     subscribeNext:^(id x) {
        NSLog(@"结束编辑");
     }];
}

///测试RACCommand的使用
- (void)testRACCommand {
    RACCommand *cmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"传值"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [cmd.executionSignals subscribeNext:^(id x) {
        NSLog(@"%@",x);
        [x subscribeNext:^(id inner) {
            NSLog(@"%@",inner);
        }];
    }];
    
    [cmd.executing subscribeNext:^(id x) {
        NSLog(@"executing");
    }];
    
    [cmd.errors subscribeNext:^(id x) {
        NSLog(@"error");
        NSLog(@"%@",x);
    }];
    
    //监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[cmd.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
    }];
    
    [cmd execute:@"执行"];
}

- (IBAction)buttonClick:(id)sender {
    [self pushToSecViewController];
}


- (void)pushToSecViewController {
    SecViewController *sec = [[SecViewController alloc]init];
    sec.delegateSubject = [RACSubject subject];
    [sec.delegateSubject subscribeNext:^(id x) {
        NSLog(@"%@",x);
        self.view.backgroundColor = (UIColor *)x;
    }];
    sec.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sec animated:YES];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
