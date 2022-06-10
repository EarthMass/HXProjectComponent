//
//  WLPhotoSelectCell.h
//  WeLiveApp
//
//  Created by guohx on 2018/11/17.
//  Copyright © 2018年 Girllive Co.,Ltd. All rights reserved.
//

#import "HXCollectionView.h"

@interface PhotoSelectCell : UITableViewCell

@property (nonatomic, strong) HXCollectionView * photoSelectView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showView:(UIViewController *)showView tableView:(UITableView *)tableView;



@end
