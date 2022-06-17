//
//  YYTextDemo.m
//  HXProjectComponent
//
//  Created by Guo on 2022/6/16.
//

#import "YYTextDemo.h"
#import <YYText/YYLabel.h>
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "UIMicro.h"

@interface YYTextDemo ()

@end

@implementation YYTextDemo
 
#pragma mark- cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- initUI
- (void)setupView {
    
   
}

- (void)link {
    NSString * rexStr = @"你好|舒服";

    NSMutableAttributedString * originStr = [[NSMutableAttributedString alloc] initWithString:@"顿饭发舒服舒服的fas你好，danfda  你好 你好 的你发的你发誓啊 你好"];
    
    NSError * error = nil;
    NSRegularExpression * rex = [[NSRegularExpression alloc] initWithPattern:rexStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    } else {
        NSArray <NSTextCheckingResult *> * resultArr = [rex matchesInString:originStr.string options:NSMatchingReportCompletion range:NSMakeRange(0, originStr.length)];
        for (NSTextCheckingResult * item in resultArr) {
            
            NSMutableAttributedString * linkStr = [[NSMutableAttributedString alloc] initWithString:[originStr.string substringWithRange:item.range]];
            linkStr.yy_font = [UIFont systemFontOfSize:16];
            linkStr.yy_color = [UIColor blueColor];
            
            YYTextBorder * border = [YYTextBorder new];
            border.cornerRadius = 3;
            border.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
            border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
            
            YYTextHighlight * highligth = [YYTextHighlight new];
            [highligth setBorder:border];
            [linkStr yy_setTextHighlight:highligth range:linkStr.yy_rangeOfAll];
            
            [originStr replaceCharactersInRange:item.range withAttributedString:linkStr];
        }
    }
    
    YYLabel * linkLab = [YYLabel new];
    linkLab.backgroundColor = [UIColor lightGrayColor];
    linkLab.numberOfLines = 0;
    linkLab.preferredMaxLayoutWidth = kScreenWidth - 30; //计算高度用的
    linkLab.attributedText = originStr;
    
    [linkLab setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString * currStr = [text.string substringWithRange:range];
        NSLog(@"");
    }];
    
    [self.view addSubview:linkLab];
    [linkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(kNavBar_Height);
    }];
}

#pragma mark- Event

#pragma mark- Lazy

@end
