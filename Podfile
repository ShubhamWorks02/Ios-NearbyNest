# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NearByNest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'ReachabilitySwift'
  pod 'R.swift'
  pod 'Kingfisher', '~> 7.0'
#  pod 'Alamofire'
pod 'Alamofire', '~>  4.8.2'
  # Pods for NearByNest
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386 arm64'
      end
    end
  end
end
