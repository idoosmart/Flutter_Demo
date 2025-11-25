#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_info.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'native_channel'
  s.version          = '1.0.0'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'iDo.' => 'huc@idosmart.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m,swift,c}'
  s.resources = ['Resources/icon_assets.bundle']
  s.resource_bundles = {
       'native_channel' => ['Resources/PrivacyInfo.xcprivacy']
  }
  s.static_framework = true
  s.vendored_frameworks = [
    'IDOUtils.xcframework',
  ]

  s.dependency 'Flutter'
  s.dependency 'ZIPFoundation', '~> 0.9.19'
  s.frameworks = "CoreBluetooth"
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-lc++'
   }
  #s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.swift_version = '5.0'
end
