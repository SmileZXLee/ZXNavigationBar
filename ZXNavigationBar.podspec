Pod::Spec.new do |s|
s.name         = 'ZXNavigationBar'
s.version      = '1.0.2'
s.summary      = '灵活轻量的自定义导航栏，轻松实现各种自定义效果'
s.homepage     = 'https://github.com/SmileZXLee/ZXNavigationBar'
s.license      = 'MIT'
s.authors      = {'李兆祥' => '393727164@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/SmileZXLee/ZXNavigationBar.git', :tag => s.version}
s.source_files = 'ZXNavigationBarDemo/ZXNavigationBarDemo/ZXNavigationBar/**/*'
s.resource     = 'ZXNavigationBarDemo/ZXNavigationBarDemo/ZXNavigationBar/ZXNavigationBar.bundle'
s.requires_arc = true
end