# frozen_string_literal: true

RSpec.describe YAAF::Form do
  class TestForm < YAAF::Form
    attr_accessor :name

    def initialize(args)
      super(args)

      @models = [User.new(name: args[:name])]
    end
  end

  describe '#save' do
    subject { TestForm.new(args).save }

    context 'with valid values' do
      let(:args) do
        { name: 'John' }
      end

      it 'returns true' do
        expect(subject).to eq true
      end

      it 'saves the user' do
        expect { subject }.to change { User.count }.by 1
      end
    end

    context 'with invalid values' do
      let(:args) do
        { name: nil }
      end

      it 'returns false' do
        expect(subject).to eq false
      end

      it 'does not save the user' do
        expect { subject }.not_to change { User.count }
      end
    end
  end
end
