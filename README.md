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
- [x] 每个控制器单独管理自己的导航栏，导航栏属于控制器的子view，不再属于统一的导航控制器
- [x] 兼容iOS8-iOS14，兼容刘海屏、iPad等各种设备，适配横竖屏，无需担心系统更新需要重新适配导航栏
- [x] 仅需一行代码即可轻松设置导航栏背景图片、背景色、导航栏渐变、状态栏颜色、Item大小和边距等各类属性
- [x] 仅需一行代码即可实现拦截pop手势与点击返回事件，并决定是否要响应pop操作
- [x] 仅需一行代码即可解决scrollView横向滚动与pop手势冲突问题
- [x] 支持随时切换为系统导航栏，且与系统导航栏之间无缝衔接
- [x] 支持自定义`ZXNavigationBar`高度
- [x] 支持在`ZXNavigationBar`上自定义titleView与navItemView
- [x] 若`ZXNavigationBar`自带效果都无法满足，支持任意自定义导航栏View
- [x] 支持导航栏折叠、支持跟随ScrollView滚动透明度自动改变
- [x] 支持通过url加载导航栏Item图片
- [x] 支持全屏手势返回
- [x] 支持自定义手势返回范围
- [x] 支持监听手势返回进度
- [x] 若从Xib中加载控制器View，添加子View无需手动设置距离导航栏顶部约束，`ZXNavigationBar`会自动处理


### 效果预览
导航栏设置 | 仿微博热搜效果 |  自定义导航栏  
-|-|-
![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo1.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo2.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo3.gif) |

自定义titleView | 兼容scrollView横向滚动 |   可伸缩式导航栏
-|-|-
![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo4.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo8.gif) | ![](http://www.zxlee.cn/github/ZXNavigationBar/ZXNavigationBarDemo6.gif) | 

### 开始使用
#### 将控制器继承于`ZXNavigationBarController`，建议将Base控制器继承于`ZXNavigationBarController`
```objective-c
@interface DemoBaseViewController : ZXNavigationBarController

@end
```
#### 【建议，非必须】将导航控制器继承于`ZXNavigationBarNavigationController`，建议将Base导航控制器继承于`ZXNavigationBarNavigationController`
```objective-c
@interface DemoBaseNavigationController : ZXNavigationBarNavigationController

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


* 【导航控制器为`ZXNavigationBarNavigationController`或其子类时，可忽略此步操作！！】`ZXNavigationBarController`作了自动隐藏导航栏的处理，但由于导航栏早于内部子控制器加载，因此有可能造成自定义导航栏抖动或状态栏颜色黑白相嵌的问题，
若您遇到此问题，请在base导航控制器的`pushViewController:animated:`中设置`self.navigationBarHidden = YES;`或在Appdelegate的`application:didFinishLaunchingWithOptions:`中调用方法`[UINavigationController zx_hideAllNavBar]`(需要先`#import "ZXNavigationBarController.h"`)
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


#### 【重要】`ZXNavigationBar`对于自定义导航栏view内容无法自动下移的处理方式
如果App使用的是系统的导航栏且不透明，view的内容会自动下移，例如非刘海屏会下移64像素；若设置了自定义的导航栏，因为它实际上就是普通的View，则控制器view中的内容不会自动下移以避免挡住导航栏。
* `ZXNavigationBar`的处理方法是：
* 如果您是通过frame或者Masonry设置控件布局，请设置y距离顶部高度为导航栏高度，可直接使用`ZXNavBarHeight`这个宏
* 如果您是通过Xib加载控制器View，则`ZXNavigationBar`会自动将内部约束设置为距离顶部为导航栏高度+原始高度，您无需作任何处理
* 若您是通过Xib加载控制器View，且禁用了SafeArea，请设置（若使用了SafeArea，请忽略）：

### 导航栏设置
#### 注意:以下设置均在控制器中进行，self代表当前控制器(当前控制器需继承于`ZXNavigationBarController`)
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
self.zx_navTitleColor = [UIColor redColor];
```
#### 设置导航栏标题字体大小
```objective-c
self.zx_navTitleFontSize = 20;
```
或

```objective-c
self.zx_navTitleFont = [UIFont systemFontOfSize:20];
```

* 设置导航栏标题其他非frame属性，通过控制`self.zx_navTitleLabel`即可

#### 设置导航栏默认返回按钮图片，若不设置则使用默认的返回按钮图片
```objective-c
self.zx_backBtnImageName = @"newBackImageName";
```

#### 快速设置左侧/右侧的按钮和点击回调(以最右侧按钮为例)
* 设置最右侧按钮的图片名和点击回调
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
* 设置最右侧按钮的图片对象和点击回调
```objective-c
[self zx_setRightBtnWithImg:image对象 clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
    NSLog(@"点击了最右侧的Button");  
}];
```

* 设置最右侧按钮的图片Url和点击回调(需导入SDWebImage并在pch文件中#import <SDWebImage/UIButton+WebCache.h>)
```objective-c
[self zx_setRightBtnWithImgUrl:@"图片url地址" placeholderImgName:@"占位图名称" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
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
* 将上述例子中`zx_navLeftBtn`/`zx_navRightBtn`修改为`zx_navSubRightBtn`即可

#### 设置左侧第二个按钮
* 将上述例子中`zx_navLeftBtn`/`zx_navRightBtn`修改为`zx_navSubLeftBtn`即可

#### 单独设置指定`ZXNavItemBtn`的属性（`ZXNavItemBtn`在导航栏中从左到右分别为`zx_navLeftBtn`,`zx_navSubLeftBtn`,`zx_navSubRightBtn`,`zx_navRightBtn`），以下以`zx_navLeftBtn`为例：

* 设置NavItemBtn的image颜色
```objective-c
self.zx_navLeftBtn.zx_imageColor = [UIColor redColor];
```
* 设置NavItemBtn的tintColor
```objective-c
self.zx_navLeftBtn.zx_tintColor = [UIColor redColor];
```
* 设置NavItemBtn的字体大小
```objective-c
self.zx_navLeftBtn.zx_fontSize = 12;
```
* 设置NavItemBtn的固定宽度，若设置，则自动计算宽度无效(若需要恢复自动宽度，可设置`zx_fixWidth`为-1)
```objective-c
self.zx_navLeftBtn.zx_fixWidth = 100;
```
* 禁止自动调整NavItemBtn图片和文字的布局，若要使contentEdgeInsets、titleEdgeInsets、imageEdgeInsets等，则需要将此属性设置为NO
```objective-c
self.zx_navLeftBtn.zx_disableAutoLayoutImageAndTitle = YES;
```
* 设置NavItemBtn的固定高度，若设置，则ZXNavDefalutItemSize无效
```objective-c
self.zx_navLeftBtn.zx_fixHeight = 20;
```
* 设置NavItemBtn image的固定大小
```objective-c
self.zx_navLeftBtn.zx_fixImageSize = CGSizeMake(10,10);
```
* 设置NavItemBtn自动计算宽度后的附加宽度
```objective-c
self.zx_navLeftBtn.zx_textAttachWidth = 20;
```
* 设置NavItemBtn内部图片x轴的偏移量，负数代表左移，无title且设置了zx_fixImageSize后生效，仅改变内容imageView的位移，不会改变原始NavItemBtn的frame
```objective-c
self.zx_navLeftBtn.zx_imageOffsetX = -10;
```
* 设置NavItemBtn的tintColor仅用于UIControlStateNormal状态(请在zx_imageColor和zx_tintColor之前设置)，默认为NO
```objective-c
self.zx_navLeftBtn.zx_useTintColorOnlyInStateNormal = YES;
```
* 自定义NavItemView
```objective-c
self.zx_navLeftBtn.zx_customView = [UISwitch new];
```
* 设置NavItemBtn frame发生改变时的回调，可在这个block中return修改后的frame
```objective-c
self.zx_navLeftBtn.zx_handleFrameBlock = ^CGRect(CGRect oldFrame) {
    return CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width + 10, 30);
};
```

#### 设置导航栏背景颜色
```objective-c
self.zx_navBarBackgroundColor = [UIColor orangeColor];
```
#### 设置导航栏背景图片
```objective-c
self.zx_navBarBackgroundImage = [UIImage imageNamed:@"nav_bac"];
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
#### 自定义导航栏高度(若设置此属性，ZXNavigationBar将不再使用默认的导航栏高度)
```objective-c
self.zx_navFixHeight = 30;
```
#### 设置导航栏大小标题效果
```objective-c
[self zx_setMultiTitle:@"ZXNavigationBar" subTitle:@"subTitle"];
```
或
```objective-c
[self zx_setMultiTitle:@"ZXNavigationBar" subTitle:@"subTitle" subTitleFont:[UIFont systemFontOfSize:10] subTitleTextColor:[UIColor redColor]];
```

#### 设置分割线背景颜色
```objective-c
self.zx_navLineViewBackgroundColor = [UIColor blueColor];
```
* 分割线其他其他非frame相关属性通过`self.zx_navLineView`设置即可

#### 设置状态栏为白色
```objective-c
self.zx_navStatusBarStyle = ZXNavStatusBarStyleLight;
```
#### 设置状态栏为黑色
```objective-c
self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
```
#### 是否禁止根据zx_navStatusBarStyle自动调整状态栏颜色，默认为否
```objective-c
self.zx_disableAutoSetStatusBarStyle = YES;
```
#### 显示系统导航栏(默认为否)
```objective-c
//显示系统导航栏将会自动隐藏ZXNavigationBar
self.zx_showSystemNavBar = YES;
```
#### 隐藏ZXNavigationBar(默认为否)
```objective-c
self.zx_hideBaseNavBar = YES;
```
#### 自定义导航栏与系统导航栏平滑过渡
```objective-c
//务必仅当存在系统导航栏与自定义导航栏过渡时启用，非必要请勿启用，否则可能造成自定义导航栏跳动，若当前控制器显示了系统导航栏，请于当前控制器pop的上一个控制器中使用self.zx_navEnableSmoothFromSystemNavBar = YES)
self.zx_navEnableSmoothFromSystemNavBar = YES;
```
* 若需要更优的平滑过渡效果，请将您的导航控制器继承于`ZXNavigationBarNavigationController`或使用`ZXNavigationBarNavigationController`作为您的导航控制器

#### 禁止Xib加载控制器情况下自动将顶部View约束下移导航栏高度(默认为否)
```objective-c
self.zx_disableNavAutoSafeLayout = YES;
```
#### Xib加载控制器情况下将所有约束为top且secondItem为控制器view或safeArea的子view约束constant设置为原始长度+导航栏高度，默认为NO(仅第一个)，若设置为YES，将会遍历控制器view中的所有约束，对性能有一点影响
```objective-c
self.zx_enableAdjustNavContainerAll = YES;
```
#### 自动将顶部View约束下移导航栏高度时的回调，可拦截并自定义下移距离(从xib加载控制器view时生效)
```objective-c
//oldNavOffset:视图在xib中所设置的约束与顶部距离
//currentNavOffset:即将设置的视图与顶部的距离
//返回值为当前需要自定义设置的视图与控制器顶部的距离
self.zx_handleAdjustNavContainerOffsetBlock = ^CGFloat(CGFloat oldNavOffset, CGFloat currentNavOffset) {
    //此设置代表从xib加载控制器view时，控制器view中的内容距离控制器顶部10像素(默认距离顶部为导航栏高度)
    return 10;
};
```
#### 自定义NavItemView
```objective-c
//以zx_navLeftBtn为例
self.zx_navLeftBtn.zx_customView = [UISwitch new];
```
#### 自定义TitleView(建议自定义TitleView中的子控件与底部距离固定不变，以适配不同高度的导航栏)
```objective-c
//创建自定义View
UIView *customTitleView = [[UIView alloc]init];
[self zx_addCustomTitleView:customTitleView];
```
#### 自定义导航栏View(建议导航栏View中的子控件与底部距离固定不变，以适配不同高度的导航栏)
```objective-c
//创建自定义View
UIView *customNav = [[UIView alloc]init];
[self zx_addCustomNavBar:customNav];
```

#### 拦截侧滑返回手势和返回按钮点击事件
```objective-c
//拦截侧滑返回手势和返回按钮点击事件
self.zx_handlePopBlock = ^BOOL(ZXNavigationBarController * _Nonnull viewController, ZXNavPopBlockFrom popBlockFrom) {
    //viewController:当前控制器
    //popBlockFrom:通过什么方式(点击返回按钮或侧滑返回手势)触发pop操作
    
    //doSomething
    //返回YES则代表不禁止pop操作，返回NO则禁止pop操作
    return YES;
};
```
#### 设置全屏返回手势
```objective-c
将您的导航控制器继承于`ZXNavigationBarNavigationController`或使用`ZXNavigationBarNavigationController`作为您的导航控制器即可
```
#### 设置全屏返回手势响应范围
将您的导航控制器继承于`ZXNavigationBarNavigationController`或使用`ZXNavigationBarNavigationController`作为您的导航控制器  
注意：因设置`全屏返回手势响应范围`与`禁用全屏pop手势`属于同一导航控制器，为避免此属性被其他子控制器修改，以下代码建议写在子控制器的`-viewWillAppear`或`-viewDidAppear`中
```objective-c
//在控制器中：
//pop手势的触发范围比例，0-1，默认为1，即代表全屏触发
self.zx_popGestureCoverRatio = 0.5;
```
禁用全屏pop手势，若禁用，则pop触发范围为屏幕宽度的十分之一
```objective-c
//在控制器中：
self.zx_disableFullScreenGesture = YES;
```
#### 监听全屏返回手势进度
将您的导航控制器继承于`ZXNavigationBarNavigationController`或使用`ZXNavigationBarNavigationController`作为您的导航控制器  
注意：因`手势进度监听的block`属于同一导航控制器，为避免block被子控制器覆盖后失效，以下代码建议写在子控制器的`-viewWillAppear`或`-viewDidAppear`中
```objective-c
//在控制器中：
self.zx_handleCustomPopGesture = ^(CGFloat popOffsetProgress) {
    NSLog(@"popOffsetProgress--%lf",popOffsetProgress);
};
```

#### push自动隐藏tabbar
将您的导航控制器继承于`ZXNavigationBarNavigationController`或使用`ZXNavigationBarNavigationController`作为您的导航控制器即可
若您要禁用这一功能
```objective-c
//在控制器中：
self.navigationController.zx_disableAutoHidesBottomBarWhenPushed = YES;
```

#### 兼容pop返回手势与scrollView横向滚动手势  
注意：因`判断是否支持多层级的手势同时触发的block`属于同一导航控制器，为避免block被子控制器覆盖后失效，以下代码建议写在子控制器的`-viewWillAppear`或`-viewDidAppear`中
```objective-c
//在控制器中：
[self zx_setPopGestureCompatibleScrollView:self.scrollView];
```
#### 兼容pop返回手势与scrollView横向滚动手势（自定义处理）
当导航控制器为`ZXNavigationBarNavigationController`或继承于`ZXNavigationBarNavigationController`时，如果需要更复杂的定制化的情况，可以使用下方的方式，以下代码的作用是在scrollView滚动到第一页的时候，支持pop手势多层级同时触发，为了更好的展示效果，建议关闭scrollView的bounces。此段代码与上方效果一致  
注意：因`判断是否支持多层级的手势同时触发的block`属于同一导航控制器，为避免block被子控制器覆盖后失效，以下代码建议写在子控制器的`-viewWillAppear`或`-viewDidAppear`中
```objective-c
//在控制器中：
self.scrollView.bounces = NO;
__weak typeof(self) weakSelf = self;
self.zx_popGestureShouldRecognizeSimultaneously = ^BOOL(UIGestureRecognizer * _Nonnull otherGestureRecognizer) {
    if(weakSelf.scrollView.contentOffset.x < weakSelf.scrollView.width){
        return YES;
    }
    return NO;
};
```

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

#### 通过ScrollView滚动自动控制导航栏透明效果（仿微博热搜效果）
* 在控制器加载的时候，需要先设置导航栏透明（注意，不要直接设置导航栏的alpha或设置导航栏的背景色为[UIColor clearColor]），请使用：
```objective-c
//这一行代码实际上是把导航栏背景色的透明度改为0，仅改变RGBA中A(alpha)的值，如果导航栏有自定义背景色，则会从透明-自定义背景色过渡
self.zx_navBarBackgroundColorAlpha = 0;
```
* 在scrollViewDidScroll中
```objective-c
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //scrollView:滚动控制的scrollView，tableView或collectionView
    //fullChangeHeight:scrollView.contentOffset.y达到fullChangeHeight时，导航栏变为完全不透明
    //changeLimitNavAlphe:当导航栏透明度达到changeLimitNavAlphe时，将触发opaqueBlock，通知控制器设置导航栏不透明时的效果
    //transparentBlock:导航栏切换到透明状态时的回调（默认透明度0.7为临界点）
    //opaqueBlock:导航栏切换到不透明状态时的回调（默认透明度0.7为临界点）
    [self zx_setNavTransparentGradientsWithScrollView:scrollView fullChangeHeight:100 changeLimitNavAlphe:0.7 transparentGradientsTransparentBlock:^{
        //导航栏透明时的额外效果设置
    } transparentGradientsOpaqueBlock:^{
        //导航栏不透明时的额外效果设置
    }];
}
```
* 若需要复杂的自定义场景（例如导航栏有背景图片，因默认处理方式是通过控制导航栏背景颜色的透明度实现，因此此时需要监听导航栏透明度改变回调，并写上`self.zx_navBacImageView.alpha = alpha;`）
```objective-c
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //scrollView:滚动控制的scrollView，tableView或collectionView
    //fullChangeHeight:scrollView.contentOffset.y达到fullChangeHeight时，导航栏变为完全不透明
    //changeLimitNavAlphe:当导航栏透明度达到changeLimitNavAlphe时，将触发opaqueBlock，通知控制器设置导航栏不透明时的效果
    //changingBlock:导航栏透明度正在改变时的回调
    //transparentBlock:导航栏切换到透明状态时的回调（默认透明度0.7为临界点）
    //opaqueBlock:导航栏切换到不透明状态时的回调（默认透明度0.7为临界点）
    [self zx_setNavTransparentGradientsWithScrollView:scrollView fullChangeHeight:100 changeLimitNavAlphe:0.7 transparentGradientsChangingBlock:^(CGFloat alpha) {
        //导航栏透明度正在改变时候处理
    } transparentGradientsTransparentBlock:^{
        //导航栏透明时的额外效果设置
    } transparentGradientsOpaqueBlock:^{
        //导航栏不透明时的额外效果设置
    }];
}
```
***

## 版本记录，请查阅[Release](https://github.com/SmileZXLee/ZXNavigationBar/releases)

***

## 更多示例，可下载Demo查阅，若有任何问题，可随时在issue中提出
