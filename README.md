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
- [x] 支持在自定义`ZXNavigationBar`高度
- [x] 支持在`ZXNavigationBar`上自定义titleView
- [x] 若`ZXNavigationBar`自带效果都无法满足，支持自定义导航栏
- [x] 若从Xib中加载控制器View，添加子View无需手动设置距离导航栏顶部约束，`ZXNavigationBar`会自动处理

### 效果预览
导航栏设置 | 仿微博热搜效果 |  自定义导航栏  
-|-|-
![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo1.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo2.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo3.gif) |

自定义titleView | 切换系统导航栏 |   可伸缩式导航栏
-|-|-
![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo4.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo5.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo6.gif) | 
### 开始使用
#### 将控制器继承于`ZXNavigationBarController`，建议将Base控制器继承于`ZXNavigationBarController`
```objective-c
@interface DemoBaseViewController : ZXNavigationBarController

@end
```
#### 【重要】注意事项
* `ZXNavigationBar`会自动显示返回按钮，且实现点击pop功能，您无需设置，若需要自定义返回按钮，直接覆盖`self.zx_navLeftBtn`的图片和点击回调即可
* 如果项目中存在黑白状态栏交替的需求，建议先在base控制器的`viewDidLoad`方法中统一设置状态栏颜色，以避免设置成白色状态栏后返回上一个页面无法自动恢复为黑色状态栏
```objective-c
@interface DemoBaseViewController : ZXNavigationBarController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
}
@end
```

* `ZXNavigationBarController`作了自动隐藏导航栏的处理，但由于导航栏早于内部子控制器加载，因此有可能造成自定义导航栏抖动或状态栏颜色黑白相嵌的问题，
若您遇到此问题，请在base导航控制器的`pushViewController:animated:`中设置`self.navigationBarHidden = YES;`或在Appdelegate的`application:didFinishLaunchingWithOptions:`中调用方法`[UINavigationController zx_hideAllNavBar]`【需要先`#import "ZXNavigationBarController.h"`】
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //这个方法需要在导航控制器加载前调用
    [UINavigationController zx_hideAllNavBar];
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    DemoListViewController *vc = [[DemoListViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    self.window = window;
    return YES;
}
@end
```


#### 【重要】关于自定义导航栏view内容无法自动下移的处理方式
* 如果是系统的导航栏，view的内容会自动下移，如64像素
* 设置了自定义的导航栏，它实际上就是普通的View，则view中的内容不会自动下移以避免挡住导航栏
* `ZXNavigationBar`的处理方法是：
* 如果您是通过frame或者Masonry设置控件布局，请设置y距离顶部高度为导航栏高度，可直接使用`ZXNavBarHeight`这个宏
* 如果您是通过Xib加载控制器View，则`ZXNavigationBar`会自动将内部约束设置为距离顶部为导航栏高度+原始高度，您无需作任何处理
* 若您是通过Xib加载控制器View，且禁用了SafeArea，请设置：
```objective-c
//若大多数控制器都从Xib加载并禁用了SafeArea，可以直接在Base控制器中设置
self.zx_isEnableSafeArea = NO;
```
### 导航栏设置
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
* 设置导航栏标题其他属性，通过控制`self.zx_navTitleLabel`即可

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
* 设置导航栏左侧/右侧的按钮的其他非frame相关属性，通过控制`self.zx_navLeftBtn/zx_navRightBtn`即可

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
* 将上诉例子中`zx_navLeftBtn`/`zx_navRightBtn`修改为`zx_navSubRightBtn`即可

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
#### 自定义导航栏高度(若设置此属性，则ZXNavigationBar不会再使用默认的导航栏高度)
```objective-c
self.zx_navFixHeight = 30;
```
#### 设置导航栏大小标题效果
```objective-c
[self zx_setMultiTitle:@"ZXNavigationBar" subTitle:@"subTitle"];
```
#### 设置分割线背景颜色
```objective-c
self.zx_navLineView.backgroundColor = [UIColor blueColor];
```
* 分割线其他其他非frame相关属性通过`self.zx_navLineView`设置即可

#### 设置伸缩式导航栏
* 如果设置了控制器的Xib且在Xib中设置了子视图的约束(仅需设置展开或者折叠导航栏与动画效果速度，无需手动调整控制器View子视图的frame)
```objective-c
//第一个参数folded：控制是展开还是折叠导航栏；第二个参数speed：控制展开或收缩导航栏的速度，0-6，建议值为3；第三个参数offsetBlock：折叠动画导航栏位移回调；第四个参数completionBlock：折叠动画结束回调
[self zx_setNavFolded:YES speed:3 foldingOffsetBlock:nil foldCompletionBlock:nil];
```
* 如果是通过Frame设置控制器View的子视图（如TableView），需要在`foldingOffsetBlock`回调中控制导航栏下方View的frame，使其始终紧贴导航栏底部
```objective-c
__weak typeof(self) weakSelf = self;
[self zx_setNavFolded:shouldFold speed:3 foldingOffsetBlock:^(CGFloat offset) {
    //tableView的y值跟随这导航栏变化(导航栏高度减小，tableView的y值减小)
    weakSelf.tableView.y += offset;
    //tableView的高度值跟随这导航栏变化(导航栏高度减小，tableView高度增加)
    weakSelf.tableView.height -= offset;
} 
```
#### 设置状态栏为白色
```objective-c
self.zx_navStatusBarStyle = ZXNavStatusBarStyleLight;
```
#### 设置状态栏为黑色
```objective-c
self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
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
#### 自定义导航栏与系统导航栏平滑过渡
```objective-c
//务必仅当存在系统导航栏与自定义导航栏过渡时启用，非必要请勿启用，否则可能造成自定义导航栏跳动，若当前控制器显示了系统导航栏，请于当前控制器pop的上一个控制器中使用self.zx_navEnableSmoothFromSystemNavBar = YES)
self.zx_navEnableSmoothFromSystemNavBar = YES;
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
#### 自定义导航栏View
```objective-c
//创建自定义View
UIView *customNav = [[UIView alloc]init];
[self zx_addCustomNavBar:customNav];
```
#### 更多示例，可下载Demo查阅，若有任何问题，可随时在issue中提出






