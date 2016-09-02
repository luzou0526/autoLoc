$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auto_location/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auto_location"
  s.version     = AutoLocation::VERSION
  s.authors     = ["Lu Zou"]
  s.email       = ["luxizou.web@gmail.com@move.com"]
  s.homepage    = "https://github.com/luzou0526/autoLoc"
  s.summary     = "Valid US locations from string"
  s.description = "A light-weight gem, get valid US zipcode/city/states from any string."
  s.license     = "MIT"
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.name          = "auto-loc"
  s.require_paths = ["lib"]
end
