# SandUnPay

[![CI Status](https://img.shields.io/travis/tianNanYiHao/SandUnPay.svg?style=flat)](https://travis-ci.org/tianNanYiHao/SandUnPay)
[![Version](https://img.shields.io/cocoapods/v/SandUnPay.svg?style=flat)](https://cocoapods.org/pods/SandUnPay)
[![License](https://img.shields.io/cocoapods/l/SandUnPay.svg?style=flat)](https://cocoapods.org/pods/SandUnPay)
[![Platform](https://img.shields.io/cocoapods/p/SandUnPay.svg?style=flat)](https://cocoapods.org/pods/SandUnPay)

## Example

Example 为编译测试工程,当SandUnPay.podspec出现改动或则版本变动,均需要cd到EXample文件路径下```pod install```

## Requirements

## Installation

SandUnPay is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SandUnPay'
```
## 参考链接
[通过CocoaPods打包framework](https://www.jianshu.com/p/e744b56d57ea)

[[iOS dev] 使用cocoapods打包静态库(依赖私有库，开源库，私有库又包含静态库)](https://www.aliyun.com/jiaocheng/352443.html)

[CocoaPods 动/静态库混用封装组件化](https://www.jianshu.com/p/544df88b6a1e)

[Cocoapods生成静态库（完整）](https://www.jianshu.com/p/e572d3764e14)

[Cocoapods打包framework/静态库的注意点](https://www.jianshu.com/p/605350a7b1dd)

[关于xcode8的建立依赖其他第三方库（cocoapods管理）的静态库framework](https://blog.csdn.net/BUG_delete/article/details/72901462)

## SandUnPay.podspec 配置信息如下
```
#
# Be sure to run `pod lib lint SandUnPay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SandUnPay'
  s.version          = '0.1.5'
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

```

## Tip
###几个会用到的命令记录
1.创建cocoapods开发静态库(Static Library)的命令
> pod lib create SOCR 

2.修改SOCR.podspec配置文件后,进入Example进行更新
> pod install

3.提交源码以及git打好和SOCR.podspec配置文件中版本一致的tag
> git add -A

> git commit -m '版本0.1.0' -a

> git tag -a 0.1.0 -m '版本0.1.0'

4.编译打包.a/.framework静态库
>4.1 .a 用这个

>pod package xxx.podspec --library --force

>4.2 .framework 用这个

>pod package xxx.podspec --force --no-mangle -embedded


## 补充
打出的.framework添加到项目工程中去的时候, 还是报错了: 打出的静态库SOCR.framework中使用了Masonry, 项目工程中也使用了Masonry.
报错在于两个库还是冲突了,这显然不符合预期,

**解决方案:在项目工程中,other link 里面存在Masonry的相对路径,将项目中的 other link 保留 -ObjC,其他的删除即可**


**另一个解决方式是, 在项目的Podfile文件中, 打开 user_frameworks**

## Author

tianNanYiHao, 851085835@qq.com

## License

SandUnPay is available under the MIT license. See the LICENSE file for more info.
