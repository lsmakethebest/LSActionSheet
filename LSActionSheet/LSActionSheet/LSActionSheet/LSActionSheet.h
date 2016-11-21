//
//  LSActionSheet.h
//  LSActionSheet
//
//  Created by 刘松 on 16/11/17.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>


//按钮顺序index依次从上往下
typedef  void(^LSActionSheetBlock)(int index);


//按钮显示顺序 title 其他按钮 销毁按钮 取消按钮
@interface LSActionSheet : UIView

+(void)showWithTitle:(NSString*)title  destructiveTitle:(NSString*)destructiveTitle  otherTitles:(NSArray*)otherTitles block:(LSActionSheetBlock)block;



@end
