#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_amazonpaymentservices.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_amazonpaymentservices'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
Flutter package for Amazon Payment Services native mobile SDKs
                       DESC
  s.homepage         = 'https://paymentservices.amazon.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Amazon Payment Services' => 'pluginsaps@amazon.ae' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'PayFortSDK'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
