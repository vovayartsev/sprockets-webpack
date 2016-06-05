Gem::Specification.new do |s|
  s.name        = 'sprockets-webpack'
  s.version     = '0.0.2'
  s.date        = '2016-06-01'
  s.summary     = 'Sprockets + Webpack'
  s.description = 'require_webpack_tree directive for Sprockets'
  s.authors     = ['Vladimir Yartsev']
  s.email       = 'vovayartsev@gmail.com'
  s.files       = Dir['lib/**/*']
  s.homepage    = 'http://rubygems.org/vovayartsev/sprockets/webpack'
  s.license     = 'MIT'

  s.add_dependency 'sprockets', '>= 3.0.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
end
