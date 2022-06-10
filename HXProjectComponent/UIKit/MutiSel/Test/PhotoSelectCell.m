//
//  WLPhotoSelectCell.m
//  WeLiveApp
//
//  Created by guohx on 2018/11/17.
//  Copyright © 2018年 Girllive Co.,Ltd. All rights reserved.
//

#import "PhotoSelectCell.h"

#import <Masonry/Masonry.h>

@interface PhotoSelectCell()
@property (nonatomic, strong) UIViewController * showView;
@property (nonatomic, strong) UITableView * tableView;
@end


@implementation PhotoSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showView:(UIViewController *)showView tableView:(UITableView *)tableView {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.showView = showView;
        self.tableView = tableView;
        
        CGRect frame = self.contentView.frame;
        frame.size.width = CGRectGetMaxX(_tableView.frame);
        frame.size.height = _photoSelectView.frame.size.height;
        self.contentView.frame = frame;
        
        [self.contentView addSubview:self.photoSelectView];

        
        CGFloat margin = 0;
        [_photoSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(margin));
            make.right.equalTo(@(-margin));
            make.top.equalTo(@(margin));
         
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(margin);
            
            make.width.mas_equalTo(@(self.frame.size.width));
            make.height.mas_equalTo(@(self->_photoSelectView.frame.size.height));
            
        }];

    }
    return self;
    
}



- (HXCollectionView *)photoSelectView {
    if (!_photoSelectView) {
        
#warning 设置正确的宽高
        _photoSelectView = [[HXCollectionView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.width/4) numOfItemInRow:4 margin:10 maxPicNum:12];
        _photoSelectView.itemMargin = 10;
        _photoSelectView.showView = self.showView;
        
        _photoSelectView.canMove = NO;
        
        int numOfLine = 3;
        CGFloat w = floor(([UIScreen mainScreen].bounds.size.width - (numOfLine - 1)*_photoSelectView.itemMargin - 2*_photoSelectView.itemMargin)/numOfLine);
        _photoSelectView.itemSize = CGSizeMake(w, 80);
        
         __block typeof(self) blockSelf = self;
        __weak typeof(self) weakSelf = self;
        __weak typeof(_photoSelectView) weakPhotoSelectView = _photoSelectView;
        [_photoSelectView frameChange:^(CGRect frame) {
           
            [weakPhotoSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(frame.size.height));
            }];
            //刷新 cell 高度
            [weakSelf.tableView  beginUpdates];
            [weakSelf.tableView endUpdates];
            
            blockSelf.frame = frame;
        }];
    }
    return _photoSelectView;
}

@end
