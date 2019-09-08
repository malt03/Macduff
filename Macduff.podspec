Pod::Spec.new do |s|
  s.name             = 'Macduff'
  s.version          = '0.0.1'
  s.summary          = 'A library to download and cache images for SwiftUI.'

  s.description      = <<-DESC
Macduff is a library to download and cache images for SwiftUI.
You can create ProgressView or ErrorView, and customize ImageView.
                       DESC

  s.homepage         = 'https://github.com/malt03/Macduff'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Koji Murata' => 'malt.koji@gmail.com' }
  s.source           = { :git => 'https://github.com/malt03/Macduff.git', :tag => s.version.to_s }

  s.source_files = "Sources/**/*.swift"

  s.swift_version = "5.1"

  s.ios.deployment_target = "13.0"
  s.tvos.deployment_target = "13.0"
  s.osx.deployment_target = "10.15"
  s.watchos.deployment_target = "6.0"
end
