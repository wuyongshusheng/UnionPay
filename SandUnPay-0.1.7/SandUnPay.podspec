Pod::Spec.new do |s|
  s.name = "SandUnPay"
  s.version = "0.1.7"
  s.summary = "SandUnPay SDK"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"tianNanYiHao"=>"851085835@qq.com"}
  s.homepage = "https://github.com/tianNanYiHao/SandUnPay"
  s.description = "\u{6749}\u{5fb7}\u{5c01}\u{88c5}\u{94f6}\u{8054}SDK,\u{63d0}\u{4f9b}\u{5546}\u{6237}\u{63a5}\u{5165}\u{94f6}\u{8054}\u{652f}\u{4ed8}\u{80fd}\u{529b}"
  s.frameworks = ["Security", "CFNetwork", "SystemConfiguration", "CoreGraphics"]
  s.libraries = ["z", "stdc++", "c++"]
  s.xcconfig = {"USER_HEADER_SEARCH_PATHS"=>"SandUnPay/Classes/*.{h}"}
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/SandUnPay.embeddedframework/SandUnPay.framework'
end
