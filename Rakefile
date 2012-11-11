$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bubble-wrap/http'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  app.name = 'morph'

  # app.sdk_version = "5.1"

  app.libs += ['/usr/lib/libz.dylib', '/usr/lib/libsqlite3.dylib', '/usr/lib/libz.1.1.3.dylib']

  app.frameworks += %w( QuartzCore )

  # Parse Dependencies
  app.frameworks += %w(AudioToolbox AdSupport CFNetwork CoreGraphics CoreLocation
    MobileCoreServices Security Social StoreKit SystemConfiguration)

  app.vendor_project('vendor/Parse.framework', :static, :products => ['Parse'], :headers_dir => 'Headers')
end
