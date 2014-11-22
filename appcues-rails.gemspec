Gem::Specification.new do |s|
  s.name        = 'appcues-rails'
  s.version     = '0.0.0'
  s.date        = '2014-11-21'
  s.summary     = 'Appcues Rails'
  s.description = 'The easiest way to install Appcues in a rails app.'
  s.authors     = ['Jonathan Kim', 'Spencer Davis']
  s.email       = 'folks@appcues.com'
  s.files       = Dir["{lib}/**/*"] + ["README.md"]
  s.homepage    = 'https://github.com/appcues/appcues-rails'
  s.license       = 'MIT'

  s.add_dependency 'activesupport', '>3.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'actionpack', '>3.2.12'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'sinatra', '~> 1.4.5'
  s.add_development_dependency 'thin', '~> 1.6.2'
  s.add_development_dependency 'tzinfo'
  s.add_development_dependency 'gem-release'
end

