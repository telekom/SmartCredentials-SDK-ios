#
#  Be sure to run `pod spec lint SmartCredentialsLibrary.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.

Pod::Spec.new do |s|

  s.name         = 'SmartCredentialsLibrary'
  s.version      = "5.3.0"
  s.summary      = "SmartCredentialsLibrary summary to be added"

  s.description  = <<-DESC
  SmartCredentialsLibrary description to be added.
                   DESC

  s.homepage     = "https://github.com/kreincke/SmartCredentials-SDK-ios"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

  s.author             = { "To be added" => "To be added" }

  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.swift_version = "5.0"

  s.source       = { :git => "https://github.com/kreincke/SmartCredentials-SDK-ios.git", :tag => "#{s.version}" }

  s.source_files  = "SmartCredentials/**/*.{swift,h,m}"
  s.exclude_files = "SmartCredentials/**/*.plist"

  # Core
  s.subspec 'Core' do |sp|
    sp.source_files  = 'SmartCredentials/Core/Core/**/*.swift'
  end

  # Authentication
  s.subspec 'Authentication' do |sp|
    sp.source_files  = 'SmartCredentials/Authentication/**/*.swift'
    sp.framework = 'AppAuth'
    sp.libraries = 'libAppAuth-iOS'
  end

  # Authorization
  s.subspec 'Authorization' do |sp|
    sp.source_files  = 'SmartCredentials/Authorization/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

  # CameraScanner
  s.subspec 'CameraScanner' do |sp|
    sp.source_files  = 'SmartCredentials/CameraScanner/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

  # DocumentScanner
  s.subspec 'DocumentScanner' do |sp|
    sp.source_files  = 'SmartCredentials/DocumentScanner/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core'
    sp.framework = 'MicroBlink.framework'
  end

  # Encryption
  s.subspec 'Encryption' do |sp|
    sp.source_files  = 'SmartCredentials/Encryption/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

  # Networking
  s.subspec 'Networking' do |sp|
    sp.source_files  = 'SmartCredentials/Networking/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

  # OTP
  s.subspec 'OTP' do |sp|
    sp.source_files  = 'SmartCredentials/OTP/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core', 'SmartCredentialsLibrary/CameraScanner', 'SmartCredentialsLibrary/Storage' 
  end

  # QRLogin
  s.subspec 'QRLogin' do |sp|
    sp.source_files  = 'SmartCredentials/QRLogin/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core', 'SmartCredentialsLibrary/Authorization'
    sp.framework = 'Starscream.framework'
  end

  # Storage
  s.subspec 'Storage' do |sp|
    sp.source_files  = 'SmartCredentials/Storage/**/*.swift'
    sp.dependency 'SmartCredentialsLibrary/Core'
  end

end
