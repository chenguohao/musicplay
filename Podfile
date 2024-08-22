# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
platform :ios, '15.0'
target 'MusicPlay' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MusicPlay
  pod 'Masonry'
  pod 'SDWebImage', '~> 5.0'
  pod 'AliyunOSSiOS'
  pod 'TZImagePickerController' 
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'ReactiveObjC', '~> 3.1.1'
  pod 'ReactiveSwift'
  pod 'SDWebImageSwiftUI'

end
post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
              if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
                  target.build_configurations.each do |config|
                      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
                  end
              end
           end
        end
    end
end

