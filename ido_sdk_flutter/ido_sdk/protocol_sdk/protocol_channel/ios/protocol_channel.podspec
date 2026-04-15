#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint protocol_channel.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'protocol_channel'
  s.version          = '0.0.1'
  s.summary          = 'ido protocl_channel lib (private)'
  s.description      = <<-DESC
ido protocl_channel lib (private)
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'iDO' => 'huc@idoosmart.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.resources = ['Resources/icon_assets.bundle']
  s.resource_bundles = {
    'protocol_channel' => ['Resources/PrivacyInfo.xcprivacy']
  }
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
