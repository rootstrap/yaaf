# frozen_string_literal: true

RSpec.describe 'Valid form' do
  let(:options) { {} }
  let(:registration_form) { RegistrationForm.new(args) }
  let(:args) do
    { name: 'John' }
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
      expect { subject }.to change { User.last&.name }.to 'John'
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
      expect { subject }.to change { User.last&.name }.to 'John'
    end
  end
end
