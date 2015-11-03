require 'spec_helper'

describe EDST::Document::TypeValidator do
  context 'string' do

    let(:validator) { described_class.new(String) }

    it 'validates a String tag' do
      node = EDST::AST.new(:tag, key: 'test', value: 'ImAValue')
      validator.call(node)
    end

    it 'will fail if given an invalid tag' do
      expect { validator.call(nil) }.to raise_error(TypeError)
    end

    it 'will fail if given a tag with an invalid value' do
      node = EDST::AST.new(:tag, key: 'test', value: nil)
      expect { validator.call(node) }.to raise_error(EDST::Document::ValidationError)
    end
  end
end
