# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

plugin 'cocoapods-art', :sources => [
  'cocoapods-local'
]

source 'https://github.com/CocoaPods/Specs.git'

target 'CUEControllerDemo' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  pod "CUELive-framework", '~> 3.6.1'
  pod "CUELive-bundle-Default", '~> 3.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end