require 'spec_helper'

describe EDST::Document do
  context '.load_file' do
    it 'should load a edst file' do
      ast = described_class.load_file(fixture_pathname('simple_document.edst'))
      expect(ast).to be_instance_of(EDST::AST)
    end
  end

  context '.validate' do
    context 'a simple document' do
      it 'should validate a given node' do
        root = described_class.load_file(fixture_pathname('simple_document.edst'))
        stats = described_class.validate(root, 'simple_document')
        errors = stats.make_errors
        expect(errors).to be_empty
      end

      it 'should create errors for an invalid node' do
        root = described_class.load_file(fixture_pathname('bad_simple_document.edst'))
        stats = described_class.validate(root, 'simple_document')
        errors = stats.make_errors
        expect(errors).not_to be_empty
      end
    end

    context 'a complex document' do
      it 'should validate a given node' do
        root = described_class.load_file(fixture_pathname('complex_document.edst'))
        stats = described_class.validate(root, 'complex_document')
        errors = stats.make_errors
        expect(errors).to be_empty
      end
    end
  end
end
