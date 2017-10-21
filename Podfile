# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CryptopiaTrader' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire', '~> 4.4'
  pod 'JSSAlertView'
  pod ‘CryptoSwift’
  pod ‘PageMenu’
  pod ‘Parchment’
  pod ‘CommonCrypto’
  pod 'SwiftyBase64', '~> 1.0'
  pod 'Google-Mobile-Ads-SDK'
  pod "TextFieldEffects"


  # Pods for CryptopiaTrader
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              target.build_settings(config.name)['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
          end
      end
  end

end
