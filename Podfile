# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'EverydayWithDog' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

  # Pods for EverydayWithDog
pod 'FSCalendar'
pod 'SideMenu'
pod 'Eureka'
pod 'ImageRow', '~> 4.0'
pod 'SDWebImage'
pod 'SegementSlide', '3.0.0'
pod 'Preheat'
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Firebase/Database'
pod 'Firebase/Core'
pod 'FirebaseFirestore'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'lottie-ios'

post_install do |installer|  
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end




end
