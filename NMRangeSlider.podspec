Pod::Spec.new do |s|
  s.name                = "NMRangeSlider"
  s.version             = "1.2.2"
  s.summary             = "A custom range slider for iOS."
  s.homepage            = "https://github.com/muZZkat/NMRangeSlider"
  s.license             = 'MIT'
  s.author              = { "Murray Hughes" => "muzzkat@gmail.com" }
  s.social_media_url    = 'https://twitter.com/muzzkat'
  s.source              = { :git => "https://github.com/muZZkat/NMRangeSlider.git", :tag => 'v1.2.2'  }
  s.platform            = :ios
  s.source_files        = 'NMRangeSlider/*.{h,m}'
  s.requires_arc        = true
  s.resources           = "Media/*.xcassets"
end
