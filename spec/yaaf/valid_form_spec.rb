# frozen_string_literal: true

RSpec.describe 'Valid form' do
  let(:options) { {} }
  let(:registration_form) { RegistrationForm.new(args) }
  let(:args) do
    { email: 'test@example.com', name: 'John' }
  end

  before do
    expect(registration_form).to be_valid
  end

  describe '#save' do
    subject { registration_form.save(options) }

    it 'returns true' do
      expect(subject).to eq true
    end

    it 'saves the user' do
      expect { subject }.to change { User.count }.by 1
    end

    it 'saves with correct information' do
      expect { subject }.to change {
        User.last&.email
      }.to('test@example.com').and change {
        User.last&.name
      }.to('John')
    end
  end

  describe '#save!' do
    subject { registration_form.save!(options) }

    it 'returns true' do
      expect(subject).to eq true
    end

    it 'saves the user' do
      expect { subject }.to change { User.count }.by 1
    end

    it 'saves with correct information' do
      expect { subject }.to change {
        User.last&.email
      }.to('test@example.com').and change {
        User.last&.name
      }.to('John')
    end
  end

  describe '#valid?' do
    subject { registration_form.valid? }

    it { is_expected.to be true }
  end

  describe '#invalid?' do
    subject { registration_form.invalid? }

    it { is_expected.to be false }
  end

  describe '#errors' do
    subject do
      registration_form.valid?
      registration_form.errors
    end

    it 'returns the correct class' do
      expect(subject.class).to eq(ActiveModel::Errors)
    end

    it 'is empty' do
      expect(subject.messages).to be_empty
    end
  end
end
