# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'iOSBaseSource' do
  use_frameworks!
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'SwiftEventBus', '5.0.0'
  pod 'Swinject', '2.6.0'
  pod 'IQKeyboardManagerSwift', '6.5.10'
  pod 'SwifterSwift', '5.2.0'
  pod 'Kingfisher', '7.9.1'
  pod 'SnapKit', '5.6.0'
  pod 'Alamofire','5.7.1'
  pod 'lottie-ios', '4.2.0'
  pod 'Google-Mobile-Ads-SDK', '10.12.0'
  pod 'GoogleUserMessagingPlatform'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
  end
 end
end