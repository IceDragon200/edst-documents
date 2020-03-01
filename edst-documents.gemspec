require_relative 'lib/edst/document/version'
require 'date'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'edst-documents'
  s.summary     = 'EDST Document toolkit'
  s.description = 'Extension for handling EDST documents.'
  s.date        = Time.now.to_date.to_s
  s.version     = EDST::Document::Version::STRING
  s.homepage    = 'https://github.com/IceDragon200/edst-documents/'
  s.license     = 'MIT'

  s.authors = ['Corey Powell']
  s.email  = 'mistdragon100@gmail.com'

  s.add_runtime_dependency 'edst',       '~> 1.0'
  # dev
  s.add_development_dependency 'rspec',     '~> 3.1'

  s.require_path = 'lib'
  s.executables = Dir.glob('bin/*').map { |s| File.basename(s) }
  s.files = ['Gemfile']
  s.files.concat(Dir.glob('{bin,lib,spec}/**/*'))
end
