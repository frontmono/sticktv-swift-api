#
# Be sure to run `pod lib lint StickPublicAPI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StickPublicAPI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of StickPublicAPI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'public API easy library for stick.tv service. all code developed by swift. include REST API, webrtc, signaling messaging etc'


  s.homepage         = 'https://github.com/frontmono/sticktv-swift-api'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'frontmono' => 'hkim@titanplatform.us' }
  s.source           = { :git => 'https://github.com/frontmono/sticktv-swift-api.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'StickPublicAPI/Classes/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  # s.resource_bundles = {
  #   'StickPublicAPI' => ['StickPublicAPI/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
