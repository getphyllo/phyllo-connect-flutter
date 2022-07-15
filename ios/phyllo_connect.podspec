#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint phyllo_connect.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'phyllo_connect'
  s.version          = '0.1.27'
  s.summary          = 'Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your iOS app.'
  s.description      = 'Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your iOS app. Connect SDK manages work platform authentication (credential validation, multi-factor authentication, error handling, etc).'
  s.homepage         = 'https://github.com/getphyllo/phyllo-connect-ios'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Phyllo' => 'phyl@getphyllo.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'PhylloConnect','0.2.2'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '4.2'
end
