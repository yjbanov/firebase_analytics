#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'firebase_analytics'
  s.version          = '0.0.1'
  s.summary          = 'Firebase Analytics plugin for Flutter.'
  s.description      = <<-DESC
Firebase Analytics plugin for Flutter.
                       DESC
  s.homepage         = 'https://github.com/flutter/firebase_analytics'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Google Inc.' => 'yjbanov@google.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
end
