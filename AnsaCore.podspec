Pod::Spec.new do |spec|

  spec.name         = "AnsaCore"
  spec.version      = "1.0.1"
  spec.summary      = "Payment SDK for iOS"
  spec.description  = <<-DESC
  Merchants may not have the engineering know-how or resources to build a tailored API integration with Ansa.

## Goals

- Reduce friction and time cost for proof of concept when running a pilot with a merchant.
- Enable merchant that has existing mobile app to quickly go live with Ansa APIs.
                   DESC

  spec.homepage     = "https://github.com/GetAnsa/ansa-core-ios-releases"
  spec.license      = "MIT"
  
  spec.author       = { "mcvetkovic-symphony" => "milan.cvetkovic@symphony.is" }
  
  spec.ios.deployment_target = 15.0
  
  spec.source       = { :git => "https://github.com/GetAnsa/ansa-core-ios-releases.git", :tag => "#{spec.version}" }
  spec.vendored_frameworks = "core.xcframework"
  
  # spec.resources = "Resources/*.png"
  spec.frameworks = "Foundation", "UIKit", "Combine"
  
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
