Pod::Spec.new do |s|
s.name         = 'ZXNavigationBar'
s.version      = '1.0.1'
s.summary      = '自定义导航栏，轻松快速地设置导航栏的各种效果'
s.homepage     = 'https://github.com/SmileZXLee/ZXNavigationBar'
s.license      = 'MIT'
s.authors      = {'李兆祥' => '393727164@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/SmileZXLee/ZXNavigationBar.git', :tag => s.version}
s.source_files = 'ZXNavigationBarDemo/ZXNavigationBarDemo/ZXNavigationBar/**/*'
s.resource     = 'ZXNavigationBarDemo/ZXNavigationBarDemo/ZXNavigationBar/ZXNavigationBar'
s.requires_arc = true
end