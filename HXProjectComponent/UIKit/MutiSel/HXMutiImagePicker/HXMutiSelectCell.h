//
//  HXCollectionView.h
//  CutName
//
//  Created by Guohx on 16/6/30.
//  Copyright © 2016年 howsur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMutiSelectCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;
- (void)setLongGesAction:(void(^)(NSIndexPath * index))action indexPath:(NSIndexPath *)indexPath;

@end

