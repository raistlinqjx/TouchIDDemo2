//
//  ViewController.m
//  TouchIDDemo2
//
//  Created by Qian JX on 16/9/12.
//  Copyright © 2016年 zfsoft. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "DetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize userField, pwdField, isLogin, touchIdBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin)
        [touchIdBtn setHidden:NO];
    else
        [touchIdBtn setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnPressed:(id)sender{
    [self loginWithUsername:userField.text andPassword:pwdField.text];
}

- (IBAction)touchIDBtnPressed:(id)sender{
    [self validateByTouchID];
}

//
- (void)bindingAccount{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"登录成功后绑定帐号";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        //保存用户名和密码
                                        [[NSUserDefaults standardUserDefaults] setObject:userField.text forKey:@"userName"];
                                        [[NSUserDefaults standardUserDefaults] setObject:pwdField.text forKey:@"password"];
                                        //接着进入详情
                                        UIAlertController *successController = [UIAlertController alertControllerWithTitle:@"帐号绑定" message:@"绑定成功" preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *aciton){
                                            [self enterDetail];
                                        }];
                                        [successController addAction:okAction];
                                        [self presentViewController:successController animated:YES completion:nil];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController *alertControlloer = [UIAlertController alertControllerWithTitle:@"绑定失败" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action){
                                                                                       NSLog(@"");
                                                                                   }];
                                        [alertControlloer addAction:ok];
                                        [self presentViewController:alertControlloer animated:YES completion:nil];
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertControlloer = [UIAlertController alertControllerWithTitle:@"错误" message:@"无法进行TouchID绑定" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           NSLog(@"");
                                                       }];
            [alertControlloer addAction:ok];
            [self presentViewController:alertControlloer animated:YES completion:nil];
        });
    }

}

//TouchID验证登录
- (void)validateByTouchID{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"TouchID验证登录";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
                                        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
                                        [self loginWithUsername:userName andPassword:password];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController *alertControlloer = [UIAlertController alertControllerWithTitle:@"错误" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action){
                                                                                       NSLog(@"");
                                                                                   }];
                                        [alertControlloer addAction:ok];
                                        [self presentViewController:alertControlloer animated:YES completion:nil];
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertControlloer = [UIAlertController alertControllerWithTitle:@"错误" message:@"无法进行TouchID验证" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           NSLog(@"");
                                                       }];
            [alertControlloer addAction:ok];
            [self presentViewController:alertControlloer animated:YES completion:nil];
        });
    }

}

- (void)loginWithUsername:(NSString *)userName andPassword:(NSString *)pwd{
    if ([userName isEqualToString:@"994"] && [pwd isEqualToString:@"123456"]){
        NSLog(@"登录成功");
        if (!isLogin){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [self bindingAccount];
        }
        else{
            [self enterDetail];
        }
    }
    else{
        NSLog(@"登录失败");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)enterDetail{
    DetailViewController *controller = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
