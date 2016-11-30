//
//  SecViewController.h
//  testRACDemo
//
//  Created by tb on 16/11/30.
//  Copyright © 2016年 com.tb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

@interface SecViewController : UIViewController

@property (nonatomic,strong) RACSubject *delegateSubject;

@end
