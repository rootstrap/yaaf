# frozen_string_literal: true

RSpec.describe 'Commit callbacks' do
  let(:options) { {} }
  let(:form) { WithCommitCallbacksForm.new(args) }
  let(:args) do
    { name: name, after_counter: 0 }
  end

  describe '#save' do
    subject { form.save(options) }

    context 'when the form is valid' do
      let(:name) { 'John' }

      it 'increments the after_counter by one' do
        expect { subject }.to change { form.after_counter }.by(1)
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'does not increment the after_counter' do
        expect { subject }.to_not change { form.after_counter }
      end
    end
  end

  describe '#save!' do
    subject { form.save!(options) }

    context 'when the form is valid' do
      let(:name) { 'John' }

      it 'increments the after_counter by one' do
        expect { subject }.to change { form.after_counter }.by(1)
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'does not increment the after_counter' do
        expect { subject rescue nil }.to_not change { form.after_counter }
      end
    end
  end
end