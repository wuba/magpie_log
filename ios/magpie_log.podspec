#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'magpie_log'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for magpie_log'
  s.description      = <<-DESC
  magpie_log
                         DESC
  s.homepage         = 'https://github.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Team' => 'flutter-dev@googlegroups.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.platform = :ios, '8.0'
end
