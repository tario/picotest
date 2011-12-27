require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require "rspec/core/rake_task"

spec = Gem::Specification.new do |s|
  s.name = 'picotest'
  s.version = '0.0.1'
  s.author = 'Dario Seminara'
  s.email = 'robertodarioseminara@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Test pico framework. One-line test suite'
  s.homepage = "http://github.com/tario/picotest"
  s.has_rdoc = true
  s.extra_rdoc_files = [ 'README' ]
  s.files = Dir.glob("{benchmarks,examples,lib,spec}/**/*") +[ 'LICENSE', 'AUTHORS', 'README', 'Rakefile', 'CHANGELOG' ]
end

desc 'Run tests'

RSpec::Core::RakeTask.new("test:units") do |t|
  t.pattern= 'spec/**/*.rb'
end

desc 'Generate RDoc'
Rake::RDocTask.new :rdoc do |rd|
  rd.rdoc_dir = 'doc'
  rd.rdoc_files.add 'lib', 'README'
  rd.main = 'README'
end

desc 'Build Gem'
Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = true
end

desc 'Clean up'
task :clean => [ :clobber_rdoc, :clobber_package ]

desc 'Clean up'
task :clobber => [ :clean ]

