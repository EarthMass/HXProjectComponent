//
//  HBCusHUDView.m
//  QiangHongBao
//
//  Created by Guo on 2022/6/6.
//

#import "HXHUDImgView.h"

@implementation HXHUDImgView

- (CGSize)intrinsicContentSize {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (CGSizeEqualToSize(self.hudImgSize, CGSizeZero)) {
        self.hudImgSize = CGSizeMake(80, 80);
    }
    CGFloat height = self.hudImgSize.height;
    CGFloat width = self.hudImgSize.width;
    return CGSizeMake(width, height);
}
@end
