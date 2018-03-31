
Pod::Spec.new do |s|
  s.name             = 'SwiftyComments'
  s.version          = '0.1.0'
  s.summary          = 'UITableView based component designed to display a hierarchy of expandable/foldable comments.'

  s.description      = <<-DESC
SwiftyComments is a UITableView based component designed to display a hierarchy of expandable/foldable comments.
                       DESC

  s.homepage         = 'https://github.com/tsucres/SwiftyComments'
  s.screenshots      = 'https://github.com/tsucres/SwiftyComments/raw/master/Screenshots/ImgurExample.png', 'https://github.com/tsucres/SwiftyComments/raw/master/Screenshots/HNExample.png', "https://github.com/tsucres/SwiftyComments/raw/master/Screenshots/RedditExample.png"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stéphane Sercu' => 'stefsercu@gmail.com' }
  s.source           = { :git => 'https://github.com/tsucres/SwiftyComments.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftyComments/Classes/**/*'
  s.resources = "SwiftyComments/Assets/*.xcassets"
  
  s.dependency 'SwipeCellKit'
  
  s.frameworks = 'UIKit'
end
