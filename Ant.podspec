#
# Be sure to run `pod lib lint Ant.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Ant'
  s.version          = '0.1.0'
  s.summary          = 'Ant is a modular programming tool for iOS developer.'

  s.description      = <<-DESC
    Ant is a modular programming tool for iOS developer.
    Developer can use Ant to make iOS programming easier when deal with module.
                       DESC

  s.homepage         = 'https://github.com/hujewelz/Ant'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huluobo' => 'hujewelz@163.com' }
  s.source           = { :git => 'https://github.com/hujewelz/Ant.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Ant/Classes/**/*'
  s.public_header_files = 'Ant/Classes/Public/**/*.h'
end
