Pod::Spec.new do |s|
  s.name             = "MBSimpleLoadingIndicator"
  s.version          = "1.0.0"
  s.summary          = "A super customizable loading circle for iOS."
  s.description      = "A simple way to set up a loading circle (or semi-circle or line) that lets you control the colors, sizing placement and much more, all while animating your changes. Also, this blocks click events, which can cause nasty crashes when waiting for network calls and the like to complete, -Loading, -Indicator, -LoadingIndicator, -objectivec, -ios, -iphone, -xcode"
  s.homepage         = "https://github.com/mbrenman/MBSimpleLoadingIndicator"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "mbrenman" => "mattbrenman@gmail.com" }
  s.source           = { :git => "https://github.com/mbrenman/MBSimpleLoadingIndicator.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mattbrenman'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'MBSimpleLoadingIndicator' => ['Pod/Assets/*.png']
  }
end
