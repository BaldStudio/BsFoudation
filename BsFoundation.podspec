Pod::Spec.new do |s|
  s.name         = 'BsFoundation'
  s.version      = '1.1.0'
  s.summary      = 'BsFoundation'
  s.homepage     = 'https://github.com/BaldStudio/BsFoundation.git'
  s.license      = { :type => 'MIT', :text => 'LICENSE' }
  s.author       = { 'crzorz' => 'crzorz@outlook.com' }
  s.source       = { :git => 'git@github.com:BaldStudio/BsFoundation.git', :tag => s.version.to_s}

  s.swift_version = '5.0'
  s.static_framework = true

  s.ios.deployment_target = "13.0"
  s.ios.source_files = 'BsFoundation/Sources/*'
    
  s.ios.frameworks = 'UIKit'
    
  s.ios.dependency 'BsLogging'
  s.ios.dependency 'SwiftCollections', '1.1.0'
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'BsFoundation/Sources/Core/**/*'

  end
  
  s.subspec 'UIKit' do |ss|
    ss.source_files = 'BsFoundation/Sources/UIKit/**/*'
  end
end
