//
//  HXCollectionView.m
//  CutName
//
//  Created by Guohx on 16/6/30.
//  Copyright © 2016年 howsur. All rights reserved.
//

#import "HXCollectionView.h"

//照片选择 导入文件
#import "TZImagePickerController.h"
#if __has_include("UIView+TZLayout.h")
#import "UIView+TZLayout.h"
#endif
#if __has_include("UIView+Layout.h")
#import "UIView+TZLayout.h"
#endif


#import "HXMutiSelectCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

#import <Masonry/Masonry.h>

#define WhenMaxPicHiddenAdd 1

static BOOL showSheet = YES; ///<是否在外部显示sheet
static BOOL allowPickingOriginalPhoto = YES; ///<允许相册选择
static BOOL showTakePhotoBtn = NO; ///<相册显示 拍照按钮
static BOOL allowPickingVideo = NO; ///<是否允许 选择视频
static BOOL allowPickingImage = YES; ///<是否允许 选择照片

static BOOL sortAscending = YES; ///<按时间排序

@interface HXCollectionView()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate> {
    
    
}
@property (nonatomic, strong) TZImagePickerController *tzImagePickerVc;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView * collectionV;

@property (nonatomic, copy) void(^frameChange)(CGRect frame);

@property (nonatomic,assign) CGFloat  itemW;
@property (nonatomic,assign) CGFloat  itemH;
@property (nonatomic,strong) LxGridViewFlowLayout * layout;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) NSInteger oldNumOfRow;

@property (nonatomic,assign) int numOfItemInRow; ///每行显示个数 未设置默认为4

@end


@implementation HXCollectionView

- (id)initWithFrame:(CGRect)frame numOfItemInRow:(int)numOfItemInRow margin:(CGFloat)margin maxPicNum:(int)maxPicNum {
    if (self = [super initWithFrame:frame]) {
        self.numOfItemInRow = numOfItemInRow;
        self.edgeInsets = UIEdgeInsetsMake(margin, margin, margin, margin);
        self.maxPicNum = maxPicNum;
        //code ...
        self.frame = frame;
        self.oldNumOfRow = 1;
        
        [self collectionInit];
        self.userInteractionEnabled = YES;
        self.canMove = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //code ...
        self.frame = frame;
        [self collectionInit];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)layoutUpdate {
    if (!_layout) {
        _layout = [[LxGridViewFlowLayout alloc] init];
    }
    
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero)) {
        int numOfItemInRow = (_numOfItemInRow == 0)?4:_numOfItemInRow;
        _itemW = floor(self.frame.size.width - (self.edgeInsets.left + self.edgeInsets.right) - ((numOfItemInRow - 1)*_itemMargin))/ numOfItemInRow;
        _itemH = _itemW;
        CGRect currFrame = self.frame;
        currFrame.size.height = _itemH + (self.edgeInsets.top + self.edgeInsets.bottom);
        self.frame = currFrame;
        
        _layout.itemSize = CGSizeMake(_itemW, _itemH);
    } else {
        _itemW = self.itemSize.width;
        _itemH = self.itemSize.height;
        CGRect currFrame = self.frame;
        currFrame.size.height = _itemH + (self.edgeInsets.top + self.edgeInsets.bottom);
        self.frame = currFrame;
        _layout.itemSize = self.itemSize;
        _numOfItemInRow = floor(self.frame.size.width - (self.edgeInsets.left + self.edgeInsets.right))/ _itemW;
    }
//    _layout.minimumInteritemSpacing = _itemMargin;
//    _layout.minimumLineSpacing = _itemMargin;
    
    _layout.sectionInset = self.edgeInsets;
}

- (void)setNumOfItemInRow:(int)numOfItemInRow {
    _numOfItemInRow = numOfItemInRow;
    [self layoutUpdate];
    [_collectionV reloadData];
}
- (void)setMaxPicNum:(int)maxPicNum {
    _maxPicNum = maxPicNum;
    [self layoutUpdate];
    [_collectionV reloadData];
}
- (void)setItemMargin:(CGFloat)itemMargin {
    _itemMargin = itemMargin;
    [self layoutUpdate];
    [_collectionV reloadData];
    
}

- (void)setCanMove:(BOOL)canMove {
    _canMove = canMove;
    _layout.canMoveEnable = _canMove;
}
- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    [self layoutUpdate];
    [_collectionV reloadData];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//    CGPoint  currPoint = [self convertPoint:point fromView:self.superview];
//    if ([self pointInside:currPoint withEvent:event]) {
//        return self;
//    }
////
////    return [super hitTest:point withEvent:event];
//    return self;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
////    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
////    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
////        return NO;
////    }
////    return YES;
//
//    if (![NSStringFromClass([touch.view class]) isEqualToString:@"HXCollectionView"]) {
//        return NO;
//    }
//
//    return YES;
//}


#pragma mark- #############照片多选############
- (void)collectionInit {
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    [self layoutUpdate];
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:_layout];
    //    CGFloat rgb = 244 / 255.0;
    _collectionV.alwaysBounceVertical = YES;
    _collectionV.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];

    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    _collectionV.scrollEnabled = NO;
    _collectionV.userInteractionEnabled = YES;
    //    collectionV.tag = 1000 + (int)indexPath.row;
    
    [_collectionV registerClass:[HXMutiSelectCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    [self addSubview:_collectionV];
    
    CGRect frame = self.frame;
    frame.size.height = _collectionV.frame.size.height;
    self.frame = frame;
    [_collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.mas_equalTo(@(self.collectionV.frame.size.height));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = _showView.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = _showView.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (TZImagePickerController *)tzImagePickerVc {
    //!!!!: 如果不每次初始化tzImagePickerController新的则会记录之前的选中照片
//    if (!_tzImagePickerVc) {
        _tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxPicNum - _selectedPhotos.count delegate:self];
        
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
        _tzImagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        
        // 1.如果你需要将拍照按钮放在外面，不要传这个参数
        //    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
        _tzImagePickerVc.allowTakePicture = showTakePhotoBtn; // 在内部显示拍照按钮
        
        // 2. Set the appearance
        // 2. 在这里设置imagePickerVc的外观
        // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
        // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
        
        // 3. Set allow picking video & photo & originalPhoto or not
        // 3. 设置是否可以选择视频/图片/原图
        _tzImagePickerVc.allowPickingVideo = allowPickingVideo;
        _tzImagePickerVc.allowPickingImage = allowPickingImage;
        _tzImagePickerVc.allowPickingOriginalPhoto = allowPickingOriginalPhoto;
        
        // 4. 照片排列按修改时间升序
        _tzImagePickerVc.sortAscendingByModificationDate = sortAscending;
#pragma mark - 到这里为止
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [_tzImagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
        }];
//    }
    
    // 每次选择图片之前清空之前的内容 (不能清除显示标记)
    [_tzImagePickerVc.selectedAssets removeAllObjects];
    [_tzImagePickerVc.selectedModels removeAllObjects];
    return _tzImagePickerVc;
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(HXCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXMutiSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        
        cell.imageView.image = self.addImg?:[UIImage imageNamed:@"addIcon"];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.deleteBtn.hidden = YES;
        cell.isAdd = YES;
        
        
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
        cell.isAdd = NO;
    }
    
    [cell setLongGesAction:^(NSIndexPath *index) {
        
//        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"长按响应" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//        [alertV show];
        
    } indexPath:indexPath];
    
#if WhenMaxPicHiddenAdd
    //最大可选 == 选择数,隐藏添加按钮
    if (self.maxPicNum == self.selectedPhotos.count && indexPath.row == _selectedPhotos.count) {
        cell.hidden = YES;
    } else {
        cell.hidden = NO;
    }
#endif
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"++++++++collectionView+++++++++++++++++");
    if (indexPath.row == _selectedPhotos.count) {
        
        if (showSheet) {
    
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * actionPic = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            [alert addAction:actionPic];
            
            UIAlertAction * actionAlbum = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushImagePickerController];
            }];
            [alert addAction:actionAlbum];
            
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:actionCancel];
            [self.showView presentViewController:alert animated:NO completion:nil];
        } else {
            [self pushImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        }
        //ios9前
//        else if ([asset isKindOfClass:[ALAsset class]]) {
//            ALAsset *alAsset = asset;
//            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
//        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [_showView presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.allowPickingOriginalPhoto = allowPickingOriginalPhoto;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
                self->_layout.itemCount = self->_selectedPhotos.count;
                
                [collectionView reloadData];
                
                
                
//                collectionView.contentSize = CGSizeMake(0, ((self.selectedPhotos.count + 2) / 3 ) * (self->_margin + self.itemH));
            }];
            [_showView presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        
        
        [collectionView reloadData];
        
    }
}

- (void)collectionView:(HXCollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    _currCollectionView = collectionView;
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    
    self.tzImagePickerVc.maxImagesCount = _maxPicNum;// - _selectedPhotos.count;
    _tzImagePickerVc.selectedAssets = _selectedAssets;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self->_showView presentViewController:self->_tzImagePickerVc animated:YES completion:nil];
        }];
    } else {
        [_showView presentViewController:_tzImagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusNotDetermined) {
        //未授权
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
            [self takePhoto];
        }];
        return;
    }


    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)) {


        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:actionCancel];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:action];
        [self.showView presentViewController:alert animated:NO completion:nil];


    } else { // 调用相机
        //判断相册权限是否打开
        if (![[TZImageManager manager] authorizationStatusAuthorized]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:actionCancel];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:action];
            [self.showView presentViewController:alert animated:NO completion:nil];
   
        } else {

            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                self.imagePickerVc.sourceType = sourceType;

                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;


                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self->_showView presentViewController:self->_imagePickerVc animated:YES completion:nil];

                    }];


                } else {
                    [_showView presentViewController:_imagePickerVc animated:YES completion:nil];

                }

            } else {
                NSLog(@"模拟器中无法打开照相机,请在真机中使用");
            }
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    __weak __typeof(&*self)ws = self;
    
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxPicNum - _selectedPhotos.count delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = sortAscending;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
//        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError * error){
//            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
//                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
//                    [tzImagePickerVc hideProgressHUD];
//                    TZAssetModel *assetModel = [models firstObject];
//                    if (tzImagePickerVc.sortAscendingByModificationDate) {
//                        assetModel = [models lastObject];
//                    }
//                    [self->_selectedAssets addObject:assetModel.asset];
//                    [self->_selectedPhotos addObject:image];
//
//                    [ws changeFrame:self->_selectedPhotos];
//
//                    [self->_collectionV reloadData];
//
//
//                }];
//            }];
//        }];
        
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error) {
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                
                [[TZImageManager manager] getAssetsFromFetchResult:model.result completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    [self->_selectedAssets addObject:assetModel.asset];
                    [self->_selectedPhotos addObject:image];
                    
                    [ws changeFrame:self->_selectedPhotos];
                    
                    [self->_collectionV reloadData];
                    
                }];
                
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
// - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
// NSLog(@"cancel");
// }

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [_selectedPhotos removeAllObjects];
    [_selectedAssets removeAllObjects];
    [_selectedPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    
    [self changeFrame:_selectedPhotos];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //主线程 执行UI
        [self->_collectionV reloadData];
    });
    
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [_selectedPhotos addObjectsFromArray:@[coverImage]];
    [_selectedAssets addObjectsFromArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    
    [_collectionV reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}


#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;

    
    [self changeFrame:_selectedPhotos];
    
    [_collectionV performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionV deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        
        
        [self->_collectionV reloadData];
        
    }];
}

- (void)frameChange:(void(^)(CGRect frame))changeBlock {
    self.frameChange = changeBlock;
}

- (void)changeFrame:(NSArray *)photo {
    
    int numOfRow = 0;
    int numOfRowInSec = ((_numOfItemInRow == 0)?4:_numOfItemInRow);
    int numOfPic = (_maxPicNum > photo.count)?(int)(photo.count + 1):(int)photo.count;
    
    numOfRow =  (int)(numOfPic/numOfRowInSec) + (numOfPic%numOfRowInSec?1:0);
    
    if (numOfRow != _oldNumOfRow) {
        _oldFrame = self.frame;
        CGFloat newH = numOfRow*self.itemH + (numOfRow - 1)*self.itemMargin + (self.edgeInsets.top + self.edgeInsets.bottom);
        
    
        _oldFrame.size.height = newH;

        
        self.frame = self->_oldFrame;
        self.collectionV.frame = self.bounds;
        [self.collectionV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self->_oldFrame.size.height));
        }];
     
        if(self.frameChange)  self.frameChange(self.frame);
       
        _oldNumOfRow = numOfRow;
    }
    
    
}


@end

