Pod::Spec.new do |s|
  s.name             = 'QKNavigationController'
  s.version          = '0.1.0'
  s.summary          = 'A navigation controller that allows left swipe to push.'
  s.homepage         = 'https://github.com/qkzhu/QKNavigationController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qiankun' => 'lastencent@gmail.com' }
  s.source           = { :git => 'https://github.com/qkzhu/QKNavigationController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files     = 'QKNavigationController/*.{h,m}'
  s.requires_arc     = true
  s.public_header_files = 'QKNavigationController/QKNavigationController.h'
end
