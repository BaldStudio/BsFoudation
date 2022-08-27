Pod::Spec.new do |s|

  s.name         = 'BsFoundation'
  s.version      = '0.0.1'
  s.summary      = 'BsFoundation'
  s.homepage     = 'http://github.com/BsFoundation.git'
  s.license      = { :type => 'MIT', :text => 'LICENSE' }
  s.author       = { 'crzorz' => 'crzorz@outlook.com' }
  s.source       = { :git => 'http://github.com/BsFoundation.git', :tag => s.version.to_s}

  s.swift_version = '5.0'
  s.static_framework = true

  s.ios.deployment_target = "13.0"
  s.ios.source_files = 'BsFoundation/Source/**/*'
    
  s.ios.frameworks = 'UIKit'
  
  s.subspec 'BsLogger' do |ss|
    ss.ios.source_files = 'BsFoundation/Source/BsLogger/**/*'
  end

  s.subspec 'AppStore' do |ss|
    ss.ios.source_files = 'BsFoundation/Source/AppStore/**/*'
  end

  s.subspec 'SwiftPlus' do |ss|
    ss.ios.source_files = 'BsFoundation/Source/SwiftPlus/**/*'
  end

  s.subspec 'Device' do |ss|
    ss.ios.source_files = 'BsFoundation/Source/Device/**/*'
  end
  
end
