# frozen_string_literal: true
begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

require "rdoc/task"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "TokenAuth"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("lib/**/*.rb")
end

require "rspec/core/rake_task"

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec)

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

Bundler::GemHelper.install_tasks

require "rubocop/rake_task"

RuboCop::RakeTask.new

dir = File.dirname(__FILE__)

desc "Run Brakeman"
task :brakeman do
  puts `#{ File.join(dir, "bin", "brakeman") } #{ File.join(dir, ".") }`
end

desc "Run MarkDown lint"
task :mdl do
  results = `#{ File.join(dir, "bin", "mdl") } #{ File.join(dir, "README.md") }`
  unless results.strip.empty?
    puts results
    exit 1
  end
end

task :default do
  Rake::Task["spec"].invoke
  Rake::Task["rubocop"].invoke
  Rake::Task["brakeman"].invoke
  Rake::Task["mdl"].invoke
end
