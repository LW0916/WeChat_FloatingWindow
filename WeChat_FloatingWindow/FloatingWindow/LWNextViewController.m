//
//  LWNextViewController.m
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/25.
//  Copyright © 2018年 lw. All rights reserved.
//

#import "LWNextViewController.h"
#import "LWWeChatFloatingBtn.h"

@interface LWNextViewController ()

@end

@implementation LWNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
