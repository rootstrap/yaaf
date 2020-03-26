# frozen_string_literal: true

RSpec.describe 'Multiple callbacks' do
  let(:options) { {} }
  let(:form) { WithMultipleCallbacksForm.new(args) }
  let(:args) do
    { name: name, result: Hash.new(0) }
  end

  describe '#save' do
    subject { form.save(options) }

    context 'when the form is valid' do
      let(:name) { 'John' }

      it 'increments the correct values' do
        expect { subject }.to change { form.result }.to(
          after_commit_counter: 2,
          after_save_counter: 1,
          after_validation_counter: 3,
          before_save_counter: 2,
          before_validation_counter: 1
        )
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'increments the correct values' do
        expect { subject }.to change { form.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end
  end

  describe '#save!' do
    subject { form.save!(options) }

    context 'when the form is valid' do
      let(:name) { 'John' }

      it 'increments the correct values' do
        expect { subject rescue nil }.to change { form.result }.to(
          after_commit_counter: 2,
          after_save_counter: 1,
          after_validation_counter: 3,
          before_save_counter: 2,
          before_validation_counter: 1
        )
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'increments the correct values' do
        expect { subject rescue nil }.to change { form.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end
  end
end
