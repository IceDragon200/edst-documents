require 'simplecov'

def fixture_pathname(name)
  File.expand_path(File.join('fixtures', name), File.dirname(__FILE__))
end

require 'edst'

SimpleCov.start

require 'edst/document'

EDST::Document.new_schema_from_file(fixture_pathname('simple_document.edst-schema.rb'), 'simple_document')
EDST::Document.new_schema_from_file(fixture_pathname('thing.edst-schema.rb'), 'thing')
EDST::Document.new_schema_from_file(fixture_pathname('complex_document.edst-schema.rb'), 'complex_document')
