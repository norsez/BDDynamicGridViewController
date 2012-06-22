Pod::Spec.new do |s|
  s.name     = 'BDDynamicGridViewController'
  s.version  = '0.0.1'
  s.license  = 'BSD'
  s.summary  = 'Data-aware UIViewController that displays a UIView list with layout inspired by Flickr 2012 Favorite Page.'
  s.homepage = 'https://github.com/norsez/BDDynamicGridViewController'
  s.author   = { 'Norsez Orankijanan' => 'norsez@gmail.com' }
  s.source   = { :git => 'https://github.com/norsez/BDDynamicGridViewController.git', :tag => '0.0.1' }
  s.description = 'This view-controller displays a list of UIViews with layout inspired by Flickr 2012 Favorite Page'
  s.platform = :ios
  s.source_files = 'Classes', 'Classes'
  s.requires_arc = true
end
