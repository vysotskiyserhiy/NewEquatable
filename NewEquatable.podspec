Pod::Spec.new do |s|
  s.name             = 'NewEquatable'
  s.version          = '0.0.2'
  s.summary          = 'New way of implementing Equatable protocol'
  s.homepage         = 'https://github.com/vysotskiyserhiy/NewEquatable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Serhiy Vysotskiy' => 'vysotskiyserhiy@gmail.com' }
  s.source           = { :git => 'https://github.com/vysotskiyserhiy/NewEquatable.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'NewEquatable/**/*'
end
