require 'spec_helper'

describe EDST::Document::ListValidator do
  context 'list:string' do
    let(:validator) { described_class.new(EDST::Document::TypeValidator.new(String)) }

    it 'validates a node list of strings' do
      root = EDST::Document.new_list('a', 'b', 'c')
      validator.validate(root)
    end

    it 'should error if there is an invalid item in the list' do
      root = EDST::Document.new_list('a', 'b', nil)
      expect { validator.validate(root) }.to raise_error(EDST::Document::ValidationError)
    end

    it 'should error if the list is invalid' do
      expect { validator.validate(nil) }.to raise_error(TypeError)
    end
  end
end
