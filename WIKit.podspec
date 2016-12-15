Pod::Spec.new do |s|
  s.name = 'WTKit'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'Elegant HTTP Networking in Swift'
  s.homepage = 'https://github.com/swtlovewtt/WTKit'
  s.authors = { '宋文通' => 'https://github.com/swtlovewtt/WTKit' }
  s.source = { :git => 'https://github.com/swtlovewtt/WTKit.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.source_files = 'WTKit/*.swift'
end
