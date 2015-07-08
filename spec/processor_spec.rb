require 'rspec'
require 'spec_helper'
require 'processor'

describe Processor do
  describe '#initialize' do
    context 'when some arguments are missing' do
      options.keys.each do |current_key|
        it 'raises an error' do
          current_options = options.delete_if do |key, value|
            key == current_key
          end
          expect { Processor.new(current_options) }.to raise_error(KeyError, "key not found: :#{current_key}")
        end
      end
    end
  end
  context 'when the required options are present' do
    let(:processor) { Processor.new(options) }
  end
end