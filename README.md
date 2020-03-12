# ZXNavigationBar
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/SmileZXLee/ZXNavigationBar/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/ZXNavigationBar.svg?style=flat)](http://cocoapods.org/?q=ZXNavigationBar)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/ZXNavigationBar.svg?style=flat)](http://cocoapods.org/?q=ZXNavigationBar)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%208.0%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
## 安装
### 通过CocoaPods安装
```ruby
pod 'ZXNavigationBar'
```
### 或手动导入
* 将ZXNavigationBar拖入项目中。

### 导入头文件
```objective-c
#import "ZXNavigationBarController.h"
```
***
### 功能&特点
- [x] 每个控制器单独管理自己的导航栏，导航栏属于各个子控制器，不再属于统一的导航控制器
- [x] 兼容iOS8-iOS13，兼容各种设备，且无需担心系统更新需要重新适配导航栏
- [x] 仅需一行代码即可轻松控制各种效果
- [x] 支持随时切换为系统导航栏，且与系统导航栏之间无缝衔接
- [x] 支持在ZXNavigationBar上自定义titleView
- [x] 若ZXNavigationBar自带效果都无法满足，支持自定义导航栏
- [x] 若从Xib中加载控制器，添加子View无需手动设置距离导航栏顶部约束，ZXNavigationBar会自动处理

### 效果预览
导航栏设置 | 仿微博热搜效果 |  自定义导航栏  
-|-|-
![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo1.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo2.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo3.gif) |

自定义titleView | 切换系统导航栏 |   【占位，对称】
-|-|-
![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo4.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo5.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo1.gif) | 
### 开始使用
#### 将控制器继承于ZXNavigationBarController，建议将Base控制器继承于ZXNavigationBarController
```objective-c
@interface DemoBaseViewController : ZXNavigationBarController

@end
```
#### 是否启用了SafeArea，默认为否，若启用，则必须将此项设置为YES(使用Xib加载控制器时生效)
```objective-c
//若大多数控制器都从Xib加载并启用了SafeArea，可以直接在Base控制器中设置
self.zx_isEnableSafeArea = YES;
```

* 注意:ZXNavigationBar会自动显示返回按钮，且实现点击pop功能，您无需设置，若需要自定义返回按钮，直接覆盖leftBtn的设置即可
#### 设置导航栏标题
```objective-c
self.title = @"ZXNavigationBar";
```
或
```objective-c
self.zx_navTitle = @"ZXNavigationBar";
```
#### 设置导航栏标题颜色
```objective-c
self.zx_navTitleLabel.textColor = @"ZXNavigationBar";
```
#### 设置导航栏标题字体大小
```objective-c
self.zx_navTitleLabel.fontSize = [UIFont systemFontOfSize:20];
```
* 设置导航栏标题其他属性，通过控制self.zx_navTitleLabel即可

#### 快速设置左侧/右侧的按钮(以右侧按钮为例)
* 设置最右侧按钮的图片和点击回调
```objective-c
[self zx_setRightBtnWithImgName:@"set_icon" clickedBlock:^(UIButton * _Nonnull btn) {
    NSLog(@"点击了最右侧的Button");
}];
```
* 设置最右侧按钮的文字和点击回调
```objective-c
[self zx_setRightBtnWithText:@"右侧按钮" clickedBlock:^(UIButton * _Nonnull btn) {
    NSLog(@"点击了最右侧的Button");
}];
```
#### 根据左侧/右侧的按钮对象进行具体设置(以左侧按钮为例)
* 如果需要导航栏显示返回图标和返回文字
```objective-c
//由于ZXNavigationBar会自动在左侧添加返回图片和点击返回事件，因此只需要设置返回的文字即可
[self.zx_navLeftBtn setTitle:@"返回" forState:UIControlStateNormal];
```
* 设置导航栏左侧/右侧的按钮的其他非frame相关属性，通过控制self.zx_navLeftBtn/zx_navRightBtn即可

#### 将图片渲染为指定颜色
```objective-c
//将oldImage渲染为红色
UIImage *resultImage = [oldImage zx_renderingColor:[UIColor redColor]];
```
#### 设置左侧/右侧的按钮的大小
```objective-c
//将按钮宽高设置为30
self.zx_navItemSize = 30;
```
#### 设置左侧/右侧的按钮的间距与边距
```objective-c
//将按钮边距设置为0
self.zx_navItemMargin = 0;
```
#### 设置右侧第二个按钮
* 将上诉例子中zx_navLeftBtn/zx_navRightBtn修改为zx_navSubRightBtn即可

#### 设置导航栏背景颜色
```objective-c
self.zx_navBar.backgroundColor = [UIColor orangeColor];
```
#### 设置导航栏背景图片
```objective-c
self.zx_navBar.zx_bacImage = [UIImage imageNamed:@"nav_bac"];
```
#### 设置导航栏渐变背景
```objective-c
//从magentaColor到cyanColor渐变
[self zx_setNavGradientBacFrom:[UIColor magentaColor] to:[UIColor cyanColor]];
```
#### 移除导航栏渐变背景
```objective-c
[self zx_removeNavGradientBac];
```
#### 设置导航栏TintColor(此属性可以将导航栏的title颜色、左右Button的文字和图片颜色修改为TintColor)
```objective-c
self.zx_navTintColor = [UIColor yellowColor];
```
#### 设置导航栏大小标题效果
```objective-c
[self zx_setMultiTitle:@"ZXNavigationBar" subTitle:@"subTitle"];
```
#### 设置分割线背景颜色
```objective-c
self.zx_navLineView.backgroundColor = [UIColor blueColor];
```
* 分割线其他其他非frame相关属性通过self.zx_navLineView设置即可

#### 设置状态栏为白色
```objective-c
self.zx_isLightStatusBar = YES;
```
#### 设置状态栏为黑色
```objective-c
self.zx_isLightStatusBar = NO;
```
#### 显示系统导航栏(默认为否)
```objective-c
//显示系统导航栏将会自动隐藏ZXNavigationBar
self.zx_showSystemNavBar = YES;
```
#### 隐藏ZXNavigationBar(默认为否)
```objective-c
//显示系统导航栏将会自动隐藏ZXNavigationBar
self.zx_hideBaseNavBar = YES;
```
#### 禁止Xib加载控制器情况下自动将顶部View约束下移导航栏高度(默认为否)
```objective-c
self.zx_disableNavAutoSafeLayout = YES;
```
#### 自定义TitleView
```objective-c
//创建自定义View
UIView *customTitleView = [[UIView alloc]init];
[self zx_addCustomTitleView:customTitleView];
```
#### 自定义TitleView
```objective-c
//创建自定义View
UIView *customNav = [[UIView alloc]init];
[self zx_addCustomNavBar:customNav];
```
#### 关于自定义导航栏view内容无法自动下移的说明
* 如果是系统的导航栏，view的内容会自动下移，如64像素
* 设置了自定义的导航栏，实际上就是普通的View，则view中的内容不会自动下移避免挡住导航栏
* ZXNavigationBar的处理方法是：
* 如果您是通过frame或者Masonry设置控件布局，请设置y距离顶部高度为导航栏高度，可直接用ZXNavBarHeight这个宏
* 如果您是通过Xib加载控制器，则ZXNavigationBar会自动将内部约束设置为距离顶部为导航栏高度+原始高度
* 若您是通过Xib加载控制器，且启用了SafeArea，请设置：
```objective-c
//若大多数控制器都从Xib加载并启用了SafeArea，可以直接在Base控制器中设置
self.zx_isEnableSafeArea = YES;
```
# TODO






