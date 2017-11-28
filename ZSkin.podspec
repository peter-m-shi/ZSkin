Pod::Spec.new do |s|

    s.name         = "ZSkin"
    s.version      = "0.0.22"
    s.summary      = "A iOS Kit For Skin"

    s.description  = <<-DESC
        You can us ZSkin to manage your app skins. dynamic skin loader of app.
    DESC

    s.homepage     = "https://github.com/peter-m-shi/ZSkin"

    s.license      = "MIT"

    s.author       = { "peter.shi" => "peter.m.shi@outlook.com" }

    s.source       = { :git => "https://github.com/peter-m-shi/ZSkin.git", :tag => "0.0.22"}

    s.source_files  = 'ZSkin/**/*.{h,m}'

    s.requires_arc = true

    s.ios.deployment_target = '7.0'

    s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end

