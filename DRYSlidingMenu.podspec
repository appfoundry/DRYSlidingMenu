
Pod::Spec.new do |s|
  s.name             = "DRYSlidingMenu"
  s.version          = "1.3.0"
  s.summary          = "A sliding menu/slidebar framework."
  s.description      = <<-DESC
                       DRYSlidingMenu is a simple container view controller, providing basic functionality for side bars, both on the left and right side.

                       DESC
  s.homepage         = "https://github.com/AppFoundry/DRYSlidingMenu"
  s.license          = 'MIT'
  s.author           = { "Michael Seghers" => "mike.seghers@appfoundry.be" }
  s.source           = { :git => "https://github.com/appfoundry/DRYSlidingMenu.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AppFoundryBE'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

   s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
end
