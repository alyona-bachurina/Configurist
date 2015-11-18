
Pod::Spec.new do |s|
  s.name             = "Configurist"
  s.version          = "0.1.0"
  s.summary          = "Loading configs in swift."
  s.description      = <<-DESC
Swift wrapper for loading configurations from JSON and PLIST files.
                       DESC

  s.homepage         = "https://github.com/alyona-bachurina/Configurist"
  s.license          = 'MIT'
  s.author           = { "Alyona" => "a.bachurina@gmail.com" }
  s.source           = { :git => "https://github.com/alyona-bachurina/Configurist", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'ENABLE_TESTABILITY' => 'YES' }

  s.source_files = 'Pod/Classes/**/*'

end
