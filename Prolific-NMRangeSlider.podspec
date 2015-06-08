Pod::Spec.new do |s|
  s.name     = 'Prolific-NMRangeSlider'
  s.version  = '0.1.1'
  s.license  = 'MIT'
  s.summary  = 'A custom range slider. Forked from https://github.com/muZZkat/NMRangeSlider'
  s.homepage = 'https://bitbucket.org/prolificinteractive/nmrangeslider'
  s.authors  = { 'Prolific Interactive' => 'info@prolificinteractive.com' }
  s.source   = { :git => 'git@bitbucket.org:prolificinteractive/nmrangeslider.git', :tag => '0.1.0' }
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.resources = "NMRangeSlider/DefaultTheme/*.png", "NMRangeSlider/DefaultTheme7/*.png", "NMRangeSlider/MetalTheme/*.png"
end
