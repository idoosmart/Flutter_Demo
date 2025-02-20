#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint protocol_ffi.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'protocol_ffi'
  s.version          = '0.0.1'
  s.summary          = 'ido protocl_ffi lib (private)'
  s.description      = <<-DESC
  ido protocl_ffi lib (private)
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'iDO' => 'huc@idoosmart.com' }
  s.source           = { :path => '.' }
  s.platform         = :ios, '9.0'
  s.libraries  = 'iconv','z','c++'

  # s.resource_bundles = {
  #    'protocol_ffi' => ['Resources/PrivacyInfo.xcprivacy']
  # }

  s.vendored_frameworks = [
    'protocol_c.framework',
  ]

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }

  s.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => [
      'PLATFORM_TYPE=2',
      'HAVE_INTTYPES_H',
      'HAVE_PKCRYPT',
      'HAVE_STDINT_H',
      'HAVE_WZAES',
      'HAVE_ZLIB',
      'VAR_ARRAYS',
      'USE_ALLOCA',
      'NONTHREADSAFE_PSEUDOSTACK',
      'OPUS_BUILD',
      'STDC_HEADERS'
      ],
    }

  s.swift_version = '5.0'

  s.dependency 'Flutter'

 end
