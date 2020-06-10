#
# Be sure to run `pod lib lint SandUnPay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SandUnPay'
  s.version          = '0.1.7'
  s.summary          = 'SandUnPay SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  杉德封装银联SDK,提供商户接入银联支付能力
                       DESC

  s.homepage         = 'https://github.com/tianNanYiHao/SandUnPay'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tianNanYiHao' => '851085835@qq.com' }
  s.source           = { :git => '/Users/tiannanyihao/Desktop/SandUnPay', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  # 指定依赖的xocde版本
  s.ios.deployment_target = '8.0'
  # 指定资源路径(.h/.m文件))
  s.source_files = 'SandUnPay/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'SandUnPay' => ['SandUnPay/Assets/*.png']
  # }

  # 指定暴露出的.h头文件
  s.public_header_files = 'SandUnPay/Classes/SandUnPay.h','SandUnPay/Classes/SandUnPayInfo.h'
  # 指定编译出的framework为静态库
  s.static_framework  =  true
  # xcode配置 -ObjC 指令
  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
  # 依赖的公共第三方库(可多个)
  s.dependency 'MBProgressHUD'
 
  # 指定好第三方.a文件
  s.vendored_libraries = 'SandUnPay/Classes/*.{a}'
  # 指定好第三方.h头文件
  s.xcconfig = { 'USER_HEADER_SEARCH_PATHS' => 'SandUnPay/Classes/*.{h}' }
  # 系统动态库
  s.frameworks = 'Security','CFNetwork','SystemConfiguration','CoreGraphics'
  # 系统lib (去掉lib开头))
  s.libraries = 'z','stdc++','c++'
end
