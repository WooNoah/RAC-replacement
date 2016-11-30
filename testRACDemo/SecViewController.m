//
//  SecViewController.m
//  testRACDemo
//
//  Created by tb on 16/11/30.
//  Copyright © 2016年 com.tb. All rights reserved.
//

#import "SecViewController.h"


@interface SecViewController ()

//@property (nonatomic,strong) RACSequence *<##>;

@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    self.navigationItem.title = @"PageTwo";
    
    [self createButton];
    
//    [self testRACSequence];
    
    [self testRACTuple];
}


- (void)testRACTuple {
    
#if 0
    //test ARRAY
    NSArray *testArr = @[@"1",@"2",@"3",@"4"];
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:testArr];
    NSLog(@"%@",tuple[0]);
    NSLog(@"%@",tuple[1]);
    NSLog(@"%@",tuple.third);
    
#else
    //test dictionary
    NSDictionary *testDic = @{@"name":@"testData",@"age":@(20)};
    [testDic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        NSLog(@"%@",x);
        NSLog(@"%ld",(long)x.count);
        NSLog(@"%@",x[0]);
        NSLog(@"%@",x[1]);
        NSLog(@"%@",x.third);
    }];

#endif
}

- (void)testRACSequence {
    NSArray *testArr = @[@"1",@"2",@"3",@"4"];
    
    [testArr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x); ///<: 0x796386c0> ( number,1 )
    }];
    
    NSDictionary *testDic = @{@"name":@"testData",@"age":@(20)};
    
    [testDic.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
#if 1
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"%@,%@",key,value);
#else
        NSString *key = x[0];
        NSString *value = x[1];
        NSLog(@"%@,%@",key,value);
#endif
    }];
}

- (void)createButton {
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"点击传值" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 44);
    btn.center = self.view.center;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (self.delegateSubject) {
             [self.delegateSubject sendNext:self.view.backgroundColor];
             [self.delegateSubject sendCompleted];
         }
         [self.navigationController popViewControllerAnimated:YES];
     }];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
