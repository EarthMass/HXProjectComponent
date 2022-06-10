//
//  HXCollectionView.h
//  CutName
//
//  Created by Guohx on 16/6/30.
//  Copyright © 2016年 howsur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxGridViewFlowLayout.h"


@class HXCollectionView;
@protocol HXCollectionViewDelegate <NSObject>

- (NSInteger)hx_collectionView:(HXCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)hx_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)hx_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 *  自定义带属性的CollectionV
 */
@interface HXCollectionView : UIView


@property (nonatomic,strong) NSMutableArray * selectedPhotos;
@property (nonatomic,strong) NSMutableArray * selectedAssets;
@property (nonatomic,assign) BOOL  isSelectOriginalPhoto;

@property (nonatomic, strong) UIImage * addImg;
//如果使用 itemSize 会自动计算 numOfItemInRow。
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic,assign) UIEdgeInsets edgeInsets;  //CollectionView margin
@property (nonatomic,assign) CGFloat  itemMargin; //item margin
@property (nonatomic, assign) int maxPicNum; ///<最多传几张图片

@property (nonatomic,assign) BOOL  canMove; // 是否可以移动 Default NO

@property (nonatomic, strong) UIViewController * showView; ///<顶部选择弹出界面

@property (nonatomic, assign) id<HXCollectionViewDelegate> hxCollectionDelegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (id)initWithFrame:(CGRect)frame numOfItemInRow:(int)numOfItemInRow margin:(CGFloat)margin maxPicNum:(int)maxPicNum;
- (void)frameChange:(void(^)(CGRect frame))changeBlock;




@end
