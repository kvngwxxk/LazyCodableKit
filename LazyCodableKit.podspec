#
#  LazyCodableKit.podspec
#  LazyCodableKit
#
#  Created by Kangwook Lee on 5/19/25.
#

Pod::Spec.new do |s|
    s.name             = 'LazyCodableKit'
    s.version          = '1.1.2'
    s.summary          = 'Safe and flexible decoding for Swift using property wrappers.'
    s.description      = <<-DESC
    LazyCodableKit provides property wrappers like @PromisedInt and @PromisedOptionalBool
    that decode mixed or malformed values into valid Swift types with optional fallback.
    DESC
                                                            
    s.homepage         = 'https://github.com/kvngwxxk/LazyCodableKit'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Kangwook Lee' => 'kngwk.bsns@gmail.com' }
    s.source           = { :git => 'https://github.com/kvngwxxk/LazyCodableKit.git', :tag => s.version.to_s }

    s.ios.deployment_target = '13.0'
    s.macos.deployment_target = '11.0'

    s.source_files     = 'Sources/LazyCodableKit/**/*.{swift}'
    s.swift_version    = '5.7'
end
