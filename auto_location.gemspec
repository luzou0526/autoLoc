# Maintain your gem's version:
require File.expand_path('../lib/auto_location/version', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auto_location"
  s.version     = AutoLocation::VERSION
  s.authors     = ["Lu Zou"]
  s.email       = ["luxizou.web@gmail.com@move.com"]
  s.homepage    = "http://github.com/luzou0526/autoLoc"
  s.summary     = "Valid US locations from string"
  s.description = "A light-weight gem, get valid US zipcode/city/states/county from any string."
  s.license     = "MIT"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
  s.add_dependency 'fastercsv', '~> 1.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
end
