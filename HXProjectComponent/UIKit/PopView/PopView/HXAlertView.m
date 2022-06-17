//
//  HXAlertView.m
//  HXProjectComponent
//
//  Created by Guo on 2022/6/14.
//

#import "HXAlertView.h"
#if __has_include(<Masonry/Masonry.h>)

#import <Masonry/Masonry.h>

#endif
#import "UIMicro.h"
#import "UIButton+ImageTitleSpacing.h"

@interface HXAlertViewAction ()

@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, copy) void(^blk)(void);

@end

@implementation HXAlertViewAction


+ (HXAlertViewAction *)actionWithTitle:(NSString *)title blk:(void(^)(void))blk {
    
    HXAlertViewAction *btn = [HXAlertViewAction new];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
    btn.titleStr = title;
    btn.blk = blk;
    
    return btn;
}



- (NSString *)titleStr {
    return self.titleLabel.text;
}

- (void)btnClickAction:(HXAlertViewAction *)sender {
    !self.blk?:self.blk();
}

@end


@interface HXAlertView ()

@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * desLab;
@property (nonatomic, strong) UIView * cusView;

@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, copy) NSString * desStr;
@property (nonatomic, assign) HXAlertViewType type;

@property (nonatomic, strong) NSMutableArray <HXAlertViewAction *> * actions;


@end

@implementation HXAlertView

+ (HXAlertView *)alertWithTitle:(NSString *)title msg:(NSString *)msg withType:(HXAlertViewType)type {
    return [self alertWithTitle:title msg:msg cusView:nil withType:type];
}

+ (HXAlertView *)alertWithTitle:(NSString *)title msg:(NSString *)msg cusView:(UIView *)cusView withType:(HXAlertViewType)type {
    
    HXAlertView * alert = [HXAlertView new];
    alert.titleStr = title;
    alert.desStr = msg;
    alert.type = type;
    alert.cusView = cusView;
    return alert;
}

- (void)addAction:(HXAlertViewAction *)action {
    [self.actions addObject:action];
}

- (UIView *)alertView {
    CGFloat edgeSpace = 30;
    UIView * bgV = [UIView new];
    bgV.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgV];
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.width.mas_equalTo(kScreenWidth - 2*edgeSpace);
        make.bottom.offset(0);
        //        make.height.greaterThanOrEqualTo(@100);
    }];
    UIView * previousView = nil;
    if (self.titleStr.length) {
        [bgV addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.top.offset(15);
        }];
        self.titleLab.text = self.titleStr;
        previousView = self.titleLab;
    }
    if (self.desStr.length) {
        [bgV addSubview:self.desLab];
        [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom).offset(15);
            } else {
                make.top.offset(15);
            }
            
        }];
        self.desLab.text = self.desStr;
        previousView = self.desLab;
    }
    
    if (self.cusView) {
        [bgV addSubview:self.cusView];
        [self.cusView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom).offset(15);
            } else {
                make.top.offset(15);
            }
            make.left.right.offset(0);
            make.height.mas_equalTo(CGRectGetHeight(self.cusView.frame));
        }];
        previousView = self.cusView;
    }
    
    if (self.actions.count) {
        UIView * btnBgV = [UIView new];
        btnBgV.tag = 1111;
        btnBgV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [bgV addSubview:btnBgV];
        [btnBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom).offset(15);
            } else {
                make.top.offset(15);
            }
        }];
        previousView = btnBgV;
        if (self.actions.count <= 2) {
            if (self.actions.count == 1) {
                HXAlertViewAction * action = [self.actions firstObject];
                [btnBgV addSubview:action];

                [action mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0.5);
                    make.height.mas_equalTo(40);
                    make.bottom.offset(0);
                    make.left.right.offset(0);
                }];
            } else {
                //两个以内 横排显示
                NSMutableArray * itemVArr = [NSMutableArray array];
                int index = 0;
                for (HXAlertViewAction * itemV in self.actions) {
                    [btnBgV addSubview:itemV];
                    
                    [itemVArr addObject:itemV];
                    [itemV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.offset(0.5);
                        make.height.mas_equalTo(40);
                        if (index == 0) {
                            make.bottom.offset(0);
                        }
                    }];
                    index ++;
                }
                [itemVArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.5 leadSpacing:0 tailSpacing:0];
            }
            
        }
        else if (self.actions.count >= 3) {
            //三个以上竖排显示
            NSMutableArray * itemVArr = [NSMutableArray array];
            int index = 0;
            for (HXAlertViewAction * itemV in self.actions) {
                [btnBgV addSubview:itemV];
                
                [itemVArr addObject:itemV];
                [itemV mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (index == self.actions.count) {
                        make.bottom.offset(0);
                    }
                    make.height.mas_equalTo(40);
                    make.left.offset(0);
                    make.right.offset(0);
                }];
                index ++;
            }
            [itemVArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0.5 leadSpacing:0.5 tailSpacing:0];
            
            
        }
        
    }
    
    
    if (previousView) {
        //最后一个视图为按钮背景
        if (previousView.tag == 1111) {
            [previousView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-0);
            }];
        }
        else {
            [previousView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-15);
            }];
        }
        
    }
    
    bgV.layer.cornerRadius = 5;
    bgV.clipsToBounds = YES;
    [self layoutIfNeeded];
    UIView * sizeView = self;
    CGSize size = [sizeView
                   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGRect newFrame = sizeView.frame;
    newFrame.size.height = size.height;
    newFrame.size.width = size.width;
    sizeView.frame = newFrame;
    return self;
}

- (UIView *)sheetView {
    CGFloat edgeSpace = 0;
    UIView * bgV = [UIView new];
    bgV.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgV];
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.width.mas_equalTo(kScreenWidth - 2*edgeSpace);
        make.bottom.offset(0);
        //        make.height.greaterThanOrEqualTo(@100);
    }];
    UIView * previousView = nil;
    if (self.titleStr.length) {
        [bgV addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.top.offset(15);
        }];
        self.titleLab.text = self.titleStr;
        previousView = self.titleLab;
    }
    if (self.desStr.length) {
        [bgV addSubview:self.desLab];
        [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom).offset(15);
            }
            else {
                make.top.offset(15);
            }
            
        }];
        self.desLab.text = self.desStr;
        previousView = self.desLab;
    }
    
    if (self.cusView) {
        [bgV addSubview:self.cusView];
        [self.cusView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom).offset(15);
            }
            else {
                make.top.offset(15);
            }
            make.left.right.offset(0);
            make.height.mas_equalTo(CGRectGetHeight(self.cusView.frame));
        }];
        previousView = self.cusView;
    }
    
    if (self.actions.count) {
        UIView * btnBgV = [UIView new];
        btnBgV.tag = 1111;
        btnBgV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [bgV addSubview:btnBgV];
        [btnBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom).offset(15);
            }
            else {
                make.top.offset(15);
            }
        }];
        previousView = btnBgV;
        
        if (self.actions.count == 1) {
            HXAlertViewAction * action = [self.actions firstObject];
            [btnBgV addSubview:action];

            [action mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0.5);
                make.height.mas_equalTo(40);
                make.bottom.offset(0);
                make.left.right.offset(0);
            }];
        }
        else {
            NSMutableArray * itemVArr = [NSMutableArray array];
            int index = 0;
            for (HXAlertViewAction * itemV in self.actions) {
                [btnBgV addSubview:itemV];
                
                [itemVArr addObject:itemV];
                [itemV mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (index == self.actions.count) {
                        make.bottom.offset(0);
                    }
                    make.height.mas_equalTo(40);
                    make.left.offset(0);
                    make.right.offset(0);
                }];
                index ++;
            }
            [itemVArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0.5 leadSpacing:0.5 tailSpacing:0];
        }
        
        
    }
    
    
    if (previousView) {
        //最后一个视图为按钮背景
        if (previousView.tag == 1111) {
            [previousView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-kSafeArea_Height);
            }];
        } else {
            [previousView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-15 - kSafeArea_Height);
            }];
        }
        
    }
    
    self.desLab.textAlignment = NSTextAlignmentCenter;
    
    bgV.layer.cornerRadius = 5;
    bgV.clipsToBounds = YES;
    [self layoutIfNeeded];
    UIView * sizeView = self;
    CGSize size = [sizeView
                   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGRect newFrame = sizeView.frame;
    newFrame.size.height = size.height;
    newFrame.size.width = size.width;
    sizeView.frame = newFrame;
    
    return self;
}

#pragma mark- Delegate
- (UIView *)customView {
    if (self.type == HXAlertViewTypeAlert) {
        return [self alertView];
    } else {
        return [self sheetView];
    }
    
}

- (void)defaultSetting {
    if (self.type == HXAlertViewTypeAlert) {
        self.layoutType = zhPopupLayoutTypeCenter;
        self.presentationStyle = zhPopupSlideStyleFromBottom;
        self.pop.maskType = zhPopupMaskTypeBlackOpacity;
        self.pop.dismissonStyle = zhPopupSlideStyleFade;
    } else {
        self.layoutType = zhPopupLayoutTypeBottom;
        self.presentationStyle = zhPopupSlideStyleFromBottom;
        self.pop.maskType = zhPopupMaskTypeBlackOpacity;
        self.pop.dismissonStyle = zhPopupSlideStyleFade;
    }
}

- (void)show {
    [self defaultSetting];
    [super show];
}
- (void)showInView:(UIView *)view {
    [self defaultSetting];
    [super showInView:view];
}

#pragma mark- Lazy
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (UILabel *)desLab {
    if (!_desLab) {
        _desLab = [[UILabel alloc] init];
        _desLab.textColor = [UIColor blackColor];
        _desLab.font = [UIFont systemFontOfSize:14];
        _desLab.numberOfLines = 0;
    }
    return _desLab;
}


- (NSMutableArray  *)actions {
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    return _actions;
}

@end
