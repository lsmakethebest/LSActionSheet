//
//  ViewController.m
//  LSActionSheet
//
//  Created by 刘松 on 16/11/17.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import "ViewController.h"

#import "LSActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {
    
    [LSActionSheet showWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" destructiveTitle:@"退出登录" otherTitles:@[@"1111",@"2222"] block:^(int index) {
        NSLog(@"-----%d",index);
    }];

//      [LSActionSheet showWithTitle:@"确定退出？确定退出？确定退出？确定退出？确定退出？确定退出？确定退出？确定退出？确定退出？" destructiveTitle:nil otherTitles:@[@"1111",@"2222"] block:nil];

//          [LSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:@[@"1111",@"2222"] block:nil];

}

@end
