
//
//  LSActionSheet.m
//  LSActionSheet
//
//  Created by 刘松 on 16/11/17.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import "LSActionSheet.h"

//字体
#define  LSActionSheetCancelButtonFont  [UIFont systemFontOfSize:16]
#define  LSActionSheetDestructiveButtonFont  [UIFont systemFontOfSize:16]
#define  LSActionSheetOtherButtonFont  [UIFont systemFontOfSize:16]
#define  LSActionSheetTitleLabelFont  [UIFont systemFontOfSize:13]

//颜色
#define  LSActionSheetButtonBackgroundColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:1]
#define  LSActionSheetBackgroundColor [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.5]


#define  LSActionSheetTitleLabelColor  [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]

#define  LSActionSheetCancelButtonColor [UIColor blackColor]
#define  LSActionSheetDestructiveButtonColor   [UIColor redColor]
#define  LSActionSheetOtherButtonColor  [UIColor blackColor]

#define  LSActionSheetContentViewBackgroundColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:0.5]

#define  LSActionSheetButtonHighlightedColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:0.5]

//高度
#define  LSActionSheetCancelButtonHeight 50
#define  LSActionSheetDestructiveButtonHeight 50
#define  LSActionSheetOtherButtonHeight 50
#define  LSActionSheetLineHeight 1.0/[UIScreen mainScreen].scale

//底部取消按钮距离上面按钮距离

#define  LSActionSheetTopMargin 20

#define  LSActionSheetBottomMargin 5

#define  LSActionSheetLeftMargin 20


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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    LSActionSheet *sheet=[[LSActionSheet alloc]init];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
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
       CGSize size= [self.title boundingRectWithSize:CGSizeMake(LSActionSheetScreenWidth-2*LSActionSheetLeftMargin, MAXFLOAT)
                           options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName:titleLabel.font}
                           context:nil]
        .size;
        
        titleLabel.frame=CGRectMake(LSActionSheetLeftMargin, LSActionSheetTopMargin,LSActionSheetScreenWidth-2*LSActionSheetLeftMargin ,size.height );
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=LSActionSheetButtonBackgroundColor;
        view.frame=CGRectMake(0, 0, LSActionSheetScreenWidth, size.height+2*LSActionSheetTopMargin);
        [contentView addSubview:view];
        [contentView addSubview:titleLabel];
        y=size.height+2*LSActionSheetTopMargin+LSActionSheetLineHeight;

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
        y+=(LSActionSheetDestructiveButtonHeight+LSActionSheetBottomMargin);
        tag++;
        
    }else{
        y+=LSActionSheetBottomMargin;
    }

    
    UIButton *cancel=[self  createButtonWithTitle:@"取消" color:LSActionSheetCancelButtonColor font:LSActionSheetCancelButtonFont height:LSActionSheetCancelButtonHeight y:y];
    cancel.tag=tag;
    [contentView addSubview:cancel];
    
    
    contentView.backgroundColor=LSActionSheetContentViewBackgroundColor;
    CGFloat maxY= CGRectGetMaxY(contentView.subviews.lastObject.frame);
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
