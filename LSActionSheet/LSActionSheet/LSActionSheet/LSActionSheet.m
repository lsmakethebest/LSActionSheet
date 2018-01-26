
//
//  LSActionSheet.m
//  LSActionSheet
//
//  Created by 刘松 on 16/11/17.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import "LSActionSheet.h"

//字体
//title字体
#define  LSActionSheetTitleLabelFont  [UIFont systemFontOfSize:13]
//取消按钮
#define  LSActionSheetCancelButtonFont  [UIFont systemFontOfSize:18]
//销毁按钮字体
#define  LSActionSheetDestructiveButtonFont  [UIFont systemFontOfSize:18]
//其他按钮字体
#define  LSActionSheetOtherButtonFont  [UIFont systemFontOfSize:16]

//颜色
//title颜色
#define  LSActionSheetTitleLabelColor  [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]
//取消按钮颜色
#define  LSActionSheetCancelButtonColor [UIColor blackColor]
//销毁按钮颜色
#define  LSActionSheetDestructiveButtonColor  [UIColor colorWithRed:226/255.0 green:0/255.0 blue:0/255.0 alpha:1]
//其他按钮颜色
#define  LSActionSheetOtherButtonColor  [UIColor blackColor]


//高度
#define  LSActionSheetCancelButtonHeight 50
#define  LSActionSheetDestructiveButtonHeight 50
#define  LSActionSheetOtherButtonHeight 50
#define  LSActionSheetLineHeight 1.0/[UIScreen mainScreen].scale


//颜色
//按钮默认背景颜色
#define  LSActionSheetButtonBackgroundColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:1]
//按钮高亮时背景颜色
#define  LSActionSheetButtonHighlightedColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:0.5]

//整体背景阴影颜色
#define  LSActionSheetBackgroundColor [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.5]
//内容部分背景颜色 也是线的颜色
#define  LSActionSheetContentViewBackgroundColor [UIColor colorWithRed:231/255.0 green:231/255.0 blue:239/255.0 alpha:0.9]



//底部取消按钮距离上面按钮距离
#define  LSActionSheetCancelButtonTopMargin 5
//title文字顶部底部间隔
#define  LSActionSheetTitleTopMargin 20
//title文字左右间隔
#define  LSActionSheetTitleLeftMargin 20
//动画时间
#define  LSActionSheetAnimationTime 0.25


#define  LSActionSheetScreenWidth [UIScreen mainScreen].bounds.size.width
#define  LSActionSheetScreenHeight [UIScreen mainScreen].bounds.size.height



@interface LSActionSheet ()

@property (nonatomic,weak) UIView *contentView;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *destructiveTitle;
@property(nonatomic,strong) NSArray *otherTitles;


@property (nonatomic,copy) LSActionSheetBlock  block;


@end

@implementation LSActionSheet

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=LSActionSheetBackgroundColor;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tap];
        

    }
    return self;
}
-(void)handleGesture:(UITapGestureRecognizer*)tap
{
    if ([tap locationInView:tap.view].y<self.frame.size.height -self.contentView.frame.size.height) {
        [self cancel];
    }
}

+(void)showWithTitle:(NSString *)title  destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSArray *)otherTitles block:(LSActionSheetBlock)block
{
    LSActionSheet *sheet=[[LSActionSheet alloc]init];
    UIWindow *window=[[UIApplication sharedApplication].delegate window];
    sheet.frame=window.bounds;
    sheet.title=title;
    sheet.destructiveTitle=destructiveTitle;
    sheet.otherTitles=otherTitles;
    sheet.block=block;
    [sheet show];
    [window addSubview:sheet];
}

-(void)show
{
    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor whiteColor];
    self.contentView=contentView;
    
    CGFloat y=0;
    NSInteger tag=0;
    if (self.title) {
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=LSActionSheetTitleLabelFont;
        titleLabel.textColor=LSActionSheetTitleLabelColor;
        titleLabel.numberOfLines=0;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text=self.title;
        titleLabel.tag=tag;
        CGSize size= [self.title boundingRectWithSize:CGSizeMake(LSActionSheetScreenWidth-2*LSActionSheetTitleLeftMargin, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:titleLabel.font}
                                              context:nil]
        .size;
        
        titleLabel.frame=CGRectMake(LSActionSheetTitleLeftMargin, LSActionSheetTitleTopMargin,LSActionSheetScreenWidth-2*LSActionSheetTitleLeftMargin ,size.height );
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=LSActionSheetButtonBackgroundColor;
        view.frame=CGRectMake(0, 0, LSActionSheetScreenWidth, size.height+2*LSActionSheetTitleTopMargin);
        [contentView addSubview:view];
        [contentView addSubview:titleLabel];
        y=size.height+2*LSActionSheetTitleTopMargin+LSActionSheetLineHeight;
        
    }
    
    for (int i=0; i<self.otherTitles.count; i++) {
        UIButton *button=[self createButtonWithTitle:self.otherTitles[i] color:LSActionSheetOtherButtonColor font:LSActionSheetOtherButtonFont height:LSActionSheetOtherButtonHeight y:y+(LSActionSheetOtherButtonHeight+LSActionSheetLineHeight)*i];
        [contentView addSubview:button];
        if (i==self.otherTitles.count-1) {
            y=y+(LSActionSheetOtherButtonHeight+LSActionSheetLineHeight)*i+LSActionSheetOtherButtonHeight;
        }
        button.tag=tag;
        tag++;
    }
    if (self.destructiveTitle) {
        UIButton *button=[self createButtonWithTitle:self.destructiveTitle color:LSActionSheetDestructiveButtonColor font:LSActionSheetDestructiveButtonFont height:LSActionSheetDestructiveButtonHeight y:y+LSActionSheetLineHeight];
        button.tag=tag;
        [contentView addSubview:button];
        y+=(LSActionSheetDestructiveButtonHeight+LSActionSheetCancelButtonTopMargin);
        tag++;
        
    }else{
        y+=LSActionSheetCancelButtonTopMargin;
    }
    
    
    CGFloat cancelHeight=LSActionSheetCancelButtonHeight;
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
    {
        cancelHeight+=34;
    }
    
    UIButton *cancel=[self  createButtonWithTitle:@"取消" color:LSActionSheetCancelButtonColor font:LSActionSheetCancelButtonFont height:cancelHeight y:y];
    cancel.tag=tag;
    [contentView addSubview:cancel];
    
    
    contentView.backgroundColor=LSActionSheetContentViewBackgroundColor;
    CGFloat maxY= CGRectGetMaxY(contentView.subviews.lastObject.frame);
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
    {
        cancel.contentEdgeInsets=UIEdgeInsetsMake(0, 0, 25, 0);
    }
    
    contentView.frame=CGRectMake(0, self.frame.size.height-maxY, LSActionSheetScreenWidth, maxY) ;
    [self addSubview:contentView];
    
    
    CGRect frame= self.contentView.frame;
    
    CGRect newframe= frame;
    self.alpha=0.1;
    newframe.origin.y=self.frame.size.height;
    contentView.frame=newframe;
    [UIView animateWithDuration:LSActionSheetAnimationTime animations:^{
        self.contentView.frame=frame;
        self.alpha=1;
        
    }completion:^(BOOL finished) {
        
    }];
    
    
}
-(UIButton*)createButtonWithTitle:(NSString*)title  color:(UIColor*)color font:(UIFont*)font height:(CGFloat)height y:(CGFloat)y
{
    
    UIButton *button=[[UIButton alloc]init];
    button.backgroundColor=LSActionSheetButtonBackgroundColor;
    [button setBackgroundImage:[self imageWithColor:LSActionSheetButtonHighlightedColor] forState:UIControlStateHighlighted];
    button.titleLabel.font=font;
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.frame=CGRectMake(0, y, LSActionSheetScreenWidth, height);
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)click:(UIButton*)button
{
    
    if (self.block) {
        self.block((int)button.tag);
    }
    [self cancel];
}
#pragma mark - 取消
-(void)cancel
{
    
    CGRect frame= self.contentView.frame;
    frame.origin.y+=frame.size.height;
    [UIView animateWithDuration:LSActionSheetAnimationTime animations:^{
        self.contentView.frame=frame;
        self.alpha=0.1;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(UIImage*)imageWithColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, 0, 1, 1));
    [color set];
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end

