# frozen_string_literal: true

RSpec.describe 'Validation callbacks' do
  let(:options) { {} }
  let(:form) { WithValidationCallbacksForm.new(args) }
  let(:email) { 'test@example.com' }
  let(:name) { 'John' }
  let(:args) do
    { email: email, name: name, before_counter: 0, after_counter: 0 }
  end

  describe '#save' do
    subject { form.save(options) }

    context 'when the form is valid' do
      it 'increments the before_counter by one' do
        expect { subject }.to change { form.before_counter }.by(1)
      end

      it 'increments the after_counter by one' do
        expect { subject }.to change { form.after_counter }.by(1)
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'increments the before_counter by one' do
        expect { subject }.to change { form.before_counter }.by(1)
      end

      it 'increments the after_counter by one' do
        expect { subject }.to change { form.after_counter }.by(1)
      end
    end

    context 'when there is a DB exception' do
      let(:email) { nil }

      it 'increments the before_counter by one' do
        expect { subject rescue nil }.to change { form.before_counter }.by(1)
      end

      it 'increments the after_counter by one' do
        expect { subject rescue nil }.to change { form.after_counter }.by(1)
      end
    end
  end

  describe '#save!' do
    subject { form.save!(options) }

    context 'when the form is valid' do
      it 'increments the before_counter by one' do
        expect { subject }.to change { form.before_counter }.by(1)
      end

      it 'increments the after_counter by one' do
        expect { subject }.to change { form.after_counter }.by(1)
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'increments the before_counter by one' do
        expect { subject rescue nil }.to change { form.before_counter }.by(1)
      end

      it 'increments the after_counter by one' do
        expect { subject rescue nil }.to change { form.after_counter }.by(1)
      end
    end

    context 'when there is a DB exception' do
      let(:email) { nil }

      it 'increments the before_counter by one' do
        expect { subject rescue nil }.to change { form.before_counter }.by(1)
      end

      it 'increments the after_counter by one' do
        expect { subject rescue nil }.to change { form.after_counter }.by(1)
      end
    end
  end
end
