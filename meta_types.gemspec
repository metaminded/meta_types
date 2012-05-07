$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "meta_types/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "meta_types"
  s.version     = MetaTypes::VERSION
  s.authors     = ["Peter Horn"]
  s.email       = ["ph@mateminded.com"]
  s.homepage    = "http://github.com/metaminded/meta_types"
  s.summary     = "DB-Configurable type description."
  s.description = "DB-Configurable type description. Uses HStore on the models"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency "activerecord-postgres-hstore"
  s.add_dependency "pg"
end
