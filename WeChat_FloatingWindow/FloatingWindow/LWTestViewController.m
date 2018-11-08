//
//  LWTestViewController.m
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/24.
//  Copyright © 2018年 lw. All rights reserved.
//

#import "LWTestViewController.h"
#import "LWWeChatFloatingBtn.h"
@interface LWTestViewController ()

@end

@implementation LWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_right_btn"] style:UIBarButtonItemStyleDone target:self action:@selector(addFloatingBtn:)];

    // Do any additional setup after loading the view.
}
- (void)addFloatingBtn:(UIBarButtonItem *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *addAlertAction = [UIAlertAction actionWithTitle:@"添加浮窗" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [LWWeChatFloatingBtn show];
    }];
    UIAlertAction *cancelAddAlertAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:addAlertAction];
    [alertController addAction:cancelAddAlertAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
