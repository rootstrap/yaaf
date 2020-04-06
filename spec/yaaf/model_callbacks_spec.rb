# frozen_string_literal: true

RSpec.describe 'Model callbacks' do
  let(:options) { {} }
  let(:form) { WithModelCallbacksForm.new(args) }
  let(:email) { 'test@example.com' }
  let(:name) { 'John' }
  let(:args) do
    { email: email, name: name }
  end

  describe '#save' do
    subject { form.save(options) }

    context 'when the form is valid' do
      it 'increments the correct values' do
        expect { subject }.to change { form.user.result }.to(
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
        expect { subject }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end

    context 'when there is a DB exception' do
      let(:email) { nil }

      it 'increments the correct values' do
        expect { subject rescue nil }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_save_counter: 2,
          before_validation_counter: 1
        )
      end
    end
  end

  describe '#save!' do
    subject { form.save!(options) }

    context 'when the form is valid' do
      it 'increments the correct values' do
        expect { subject rescue nil }.to change { form.user.result }.to(
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
        expect { subject rescue nil }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end

    context 'when there is a DB exception' do
      let(:email) { nil }

      it 'increments the correct values' do
        expect { subject rescue nil }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_save_counter: 2,
          before_validation_counter: 1
        )
      end
    end
  end

  describe '#valid?' do
    subject { form.valid? }

    context 'when the form is valid' do
      it 'increments the correct values' do
        expect { subject }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'increments the correct values' do
        expect { subject }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end

    context 'when there is a DB exception' do
      let(:email) { nil }

      it 'increments the correct values' do
        expect { subject rescue nil }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end
  end

  describe '#invalid?' do
    subject { form.invalid? }

    context 'when the form is valid' do
      it 'increments the correct values' do
        expect { subject }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end

    context 'when the form is invalid' do
      let(:name) { '1234' }

      it 'increments the correct values' do
        expect { subject }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end

    context 'when there is a DB exception' do
      let(:email) { nil }

      it 'increments the correct values' do
        expect { subject rescue nil }.to change { form.user.result }.to(
          after_validation_counter: 3,
          before_validation_counter: 1
        )
      end
    end
  end
end
