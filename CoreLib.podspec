Pod::Spec.new do |s|
  s.name             = 'HttpsManager'
  s.version          = '0.0.1'
  s.summary          = 'summary'

  s.description      = <<-DESC
  description
                       DESC

  s.homepage         = 'https://github.com/zhang651651/HttpsManager.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '作者' => 'Albert' }
  s.source           = { :git => 'https://github.com/zhang651651/HttpsManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Classes/**/*.{swift,h,m,c}'
  s.resources = 'Assets/*'
  
  s.dependency 'AFNetworking', '~> 3.0'
end
