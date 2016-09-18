//
//  ViewController.h
//  TouchIDDemo2
//
//  Created by Qian JX on 16/9/12.
//  Copyright © 2016年 zfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isLogin;//是否登录过 YES=已登录过，非第一次进入
@property (nonatomic, retain) IBOutlet UITextField *userField;
@property (nonatomic, retain) IBOutlet UITextField *pwdField;
@property (nonatomic, retain) IBOutlet UIButton *touchIdBtn;

- (IBAction)loginBtnPressed:(id)sender;
- (IBAction)touchIDBtnPressed:(id)sender;
@end

