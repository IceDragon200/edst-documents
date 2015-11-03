require 'spec_helper'
require 'edst/document/core_ext/array'

describe Array do
  context 'choice_join' do
    it 'should join an Array of values and end with an or' do
      values = [1, 2, 3]
      expect(values.choice_join).to eq('1, 2 or 3')
    end
  end
end
