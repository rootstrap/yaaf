# frozen_string_literal: true

RSpec.describe 'Invalid model' do
  let(:options) { {} }
  let(:registration_form) { RegistrationForm.new(args) }
  let(:args) do
    { email: 'test@example.com', name: nil }
  end

  before do
    expect(registration_form.user).to_not be_valid
  end

  describe '#save' do
    subject { registration_form.save(options) }

    it 'returns false' do
      expect(subject).to eq false
    end

    it 'does not save the user' do
      expect { subject }.not_to change { User.count }
    end

    context 'when validations are skipped' do
      let(:options) { { validate: false } }

      it 'returns true' do
        expect(subject).to eq true
      end

      it 'saves the user' do
        expect { subject }.to change { User.count }.by 1
      end

      it 'saves with correct information' do
        subject

        expect(User.last.email).to eq 'test@example.com'
        expect(User.last.name).to eq nil
      end
    end
  end

  describe '#save!' do
    subject { registration_form.save!(options) }

    it 'raises an exception' do
      expect { subject }.to raise_error(ActiveModel::ValidationError)
    end

    it 'does not save the user' do
      expect { subject rescue nil }.not_to change { User.count }
    end

    context 'when validations are skipped' do
      let(:options) { { validate: false } }

      it 'returns true' do
        expect(subject).to eq true
      end

      it 'saves the user' do
        expect { subject }.to change { User.count }.by 1
      end

      it 'saves with correct information' do
        subject

        expect(User.last.email).to eq 'test@example.com'
        expect(User.last.name).to eq nil
      end
    end
  end

  describe '#valid?' do
    subject { registration_form.valid? }

    it { is_expected.to be false }
  end

  describe '#invalid?' do
    subject { registration_form.invalid? }

    it { is_expected.to be true }
  end

  describe '#errors' do
    subject do
      registration_form.valid?
      registration_form.errors
    end

    it 'returns the correct class' do
      expect(subject.class).to eq(ActiveModel::Errors)
    end

    it 'returns the form errors messages' do
      expect(subject.messages).to eq(name: ["can't be blank"])
    end
  end
end
