# 代码功能集合 2022/06/02

##  多图片选择器
###  依赖文件
```
pod 'Masonry'
pod 'TZImagePickerController'

添加权限配置，project.pbxproj 添加
INFOPLIST_KEY_NSCameraUsageDescription  = "请允许使用相机";
INFOPLIST_KEY_NSMicrophoneUsageDescription  = "请允许使用麦克风";
INFOPLIST_KEY_NSPhotoLibraryAddUsageDescription  = "请允许访问您的相册";
INFOPLIST_KEY_NSPhotoLibraryUsageDescription  = "请允许访问您的相册";  

info中添加  中文配置
    <key>CFBundleAllowMixedLocalizations</key>
    <false/>
     

添加 MobileCoreServices包, pod加载 TZImagePickerController 不需要

拷贝：HXMutiImagePicker 文件夹

```

## 分段 嵌套列表
### 依赖文件
```
    pod 'Masonry'
    pod 'GKPageScrollView'
    pod 'GKPageSmoothView'
  
    pod 'MJRefresh'
  
  #分段控件
#  pod 'JXCategoryViewExt/Core'
#  pod 'JXCategoryViewExt/Title'
    pod 'JXCategoryView'
```

## 加载提示
### 依赖文件
```
    pod 'MBProgressHUD'
    pod 'SDWebImage'
    pod 'FGPopupScheduler' # 弹窗优先级
    
```
