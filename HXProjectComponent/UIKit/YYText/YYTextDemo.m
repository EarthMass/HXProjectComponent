//
//  YYTextDemo.m
//  HXProjectComponent
//
//  Created by Guo on 2022/6/16.
//

#import "YYTextDemo.h"

#import <YYText/YYText.h>
//#import <YYImage/YYImage.h>
#import <Masonry/Masonry.h>
#import "UIMicro.h"

@interface YYTextDemo ()

@property (nonatomic, strong)  YYLabel * linkLab;
@property (nonatomic, strong)  YYLabel * addIconLab;

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
    [self link];
    [self addIconLabel];
   
}

/// 链接
- (void)link {
    NSString * rexStr = @"你好|舒服";

    NSMutableAttributedString * originStr = [[NSMutableAttributedString alloc] initWithString:@"顿饭发舒服舒服的fas你好，danfda  你好 你好 的你发的你发誓啊 你好,c顿饭发舒服舒服的fas你好，danfda  你好 你好 的你发的你发誓啊 你好顿饭发舒服舒服的fas你好，danfda  你好 你好 的你发的你发誓啊 你好顿饭发舒服舒服的fas你好，danfda  你好 你好 的你发的你发誓啊 你好"];
    originStr.yy_font = [UIFont systemFontOfSize:14];
    
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
    
    
//    //添加末尾省略
//        NSMutableAttributedString * truncationTokenString = [[NSMutableAttributedString alloc] initWithString:@"...末尾省略号"];
//        truncationTokenString.yy_color = [UIColor redColor];
//        truncationTokenString.yy_font = originStr.yy_font;
//
//        YYTextBorder * border = [YYTextBorder new];
//        border.cornerRadius = 3;
//        border.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
//        border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
//
//
//        //添加点击
//        YYTextHighlight * hight = [[YYTextHighlight alloc] init];
//        [hight setBorder:border];
//        [hight setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//            NSLog(@"展开");
//        }];
//        [truncationTokenString yy_setTextHighlight:hight range:truncationTokenString.yy_rangeOfAll];
//
//        YYLabel *seeMore = [YYLabel new];
//        seeMore.attributedText = truncationTokenString;
//        [seeMore sizeToFit];
//
//        NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:truncationTokenString.yy_font alignment:YYTextVerticalAlignmentCenter];
//
//        linkLab.truncationToken = truncationToken;
    
    //获取高度
//    YYTextLayout * layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(linkLab.preferredMaxLayoutWidth, CGFLOAT_MAX) text:linkLab.attributedText];
//    CGFloat height = layout.textBoundingSize.height;
    
    self.linkLab = linkLab;
}
/// 添加元素
- (void)addIconLabel {
    
    NSMutableAttributedString * originStr = [[NSMutableAttributedString alloc] initWithString:@"顿饭发舒服舒服的fas你好，danfda  你好 你好 的你发的你发誓啊 你好，truncationTokenString，truncationTokenString，truncationTokenString顿饭发舒服舒服的fas你好，danfda顿饭发舒服舒服的fas你好，danfda顿饭发舒服舒服的fas你好，danfda顿饭发舒服舒服的fas你好，danfda"];
    originStr.yy_font = [UIFont systemFontOfSize:14];
    [originStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(0, 3)];
    
//添加图片
    UIImage *image = [UIImage imageNamed:@"dribbble64_imageio"];
    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];

    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:originStr.yy_font alignment:YYTextVerticalAlignmentCenter];
    [originStr insertAttributedString:attachText atIndex:0];

    
    YYLabel * linkLab = [YYLabel new];
    linkLab.backgroundColor = [UIColor lightGrayColor];
    linkLab.numberOfLines = 0;
    linkLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
    linkLab.preferredMaxLayoutWidth = kScreenWidth - 30; //计算高度用的

    linkLab.textColor =  [UIColor yellowColor];
    linkLab.font = [UIFont systemFontOfSize:14];
    linkLab.attributedText = originStr; // 会重置yy_font为label的字体

    linkLab.numberOfLines = 2;
    
    [self.view addSubview:linkLab];
    [linkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.linkLab.mas_bottom).offset(10);
    }];
    
    self.addIconLab = linkLab;
    [self addExpandItem];
}

/// 展开按钮
- (void)addExpandItem {
    //添加末尾省略
        NSString * endExpandStr = @"...末尾省略号";
        NSMutableAttributedString * truncationTokenString = [[NSMutableAttributedString alloc] initWithString:endExpandStr];
        truncationTokenString.yy_color = [UIColor redColor];
    //    truncationTokenString.yy_font = originStr.yy_font; //有可能出错， inkLab.attributedText = originStr; // 会重置yy_font为label的字体
//        truncationTokenString.yy_font = self.addIconLab.font; 设置attText被重置
        truncationTokenString.yy_font = [UIFont systemFontOfSize:14];
        
        YYTextBorder * border = [YYTextBorder new];
        border.cornerRadius = 3;
        border.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
        border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
        
        __weak typeof(self) weakSelf = self;
        //添加点击
        YYTextHighlight * hight = [[YYTextHighlight alloc] init];
        [hight setBorder:border];
        [hight setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            if ([endExpandStr isEqualToString:text.string]) {
                NSLog(@"展开");
                [weakSelf changeExpand:YES label:weakSelf.addIconLab];
            } else {
                NSLog(@"折叠");
                [weakSelf changeExpand:NO label:weakSelf.addIconLab];
            }

        }];
        [truncationTokenString yy_setTextHighlight:hight range:truncationTokenString.yy_rangeOfAll];
        
        YYLabel *seeMore = [YYLabel new];
        seeMore.attributedText = truncationTokenString;
    
        [seeMore sizeToFit];
        
        NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:self.addIconLab.font alignment:YYTextVerticalAlignmentCenter];
        
      self.addIconLab.truncationToken = truncationToken;
}



/// 折叠按钮
- (void)addCompressItem {
    NSMutableAttributedString * compressStr = [[NSMutableAttributedString alloc] initWithString:@"折叠"];
    compressStr.yy_color = [UIColor redColor];
    compressStr.yy_font = [UIFont systemFontOfSize:14];
    
    YYTextBorder * border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
    border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
    
    __weak typeof(self) weakSelf = self;
    //添加点击
    YYTextHighlight * hight = [[YYTextHighlight alloc] init];
    [hight setBorder:border];
    [hight setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"折叠");
        [weakSelf changeExpand:NO label:weakSelf.addIconLab];
    }];
    [compressStr yy_setTextHighlight:hight range:compressStr.yy_rangeOfAll];
    
    NSMutableAttributedString * originStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.addIconLab.attributedText];
    if (![originStr.string hasSuffix:compressStr.string]) {
        [originStr appendAttributedString:compressStr];
    }
    self.addIconLab.attributedText = originStr;
}

- (void)changeExpand:(BOOL)expand label:(YYLabel *)label {
    if (expand) {
        label.numberOfLines = 0;
        [self addCompressItem];
        
    } else {
        label.numberOfLines = 2;
    }
}

#pragma mark- Event

#pragma mark- Lazy

@end
