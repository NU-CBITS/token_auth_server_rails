# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "token_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "token_auth"
  s.version     = TokenAuth::VERSION
  s.authors     = ["Eric Carty-Fickes"]
  s.email       = ["ericcf@northwestern.edu"]
  s.homepage    = "https://github.com/NU-CBITS/token_auth"
  s.summary     = "Rails engine for authenticating clients anonymously."
  s.description = "A Rails engine that allows for configuring secure " \
                  "communication between client and server via a shared " \
                  "human-readable token."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*",
                "MIT-LICENSE",
                "Rakefile",
                "README.md"]

  s.add_dependency "active_model_serializers", "= 0.10.0.rc3"
  s.add_dependency "actionpack", "= 5.0.1"
  s.add_dependency "activerecord", "= 5.0.1"
  s.add_dependency "railties", "= 5.0.1"
  s.add_dependency "sprockets-rails", "= 3.2.0"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 3.5.X"
  s.add_development_dependency "capybara", "~> 2.5"
  s.add_development_dependency "brakeman"
  s.add_development_dependency "rubocop", "0.47.1"
  s.add_development_dependency "mdl"
  s.add_development_dependency "simplecov", "~> 0.11"
end
