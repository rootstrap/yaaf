# frozen_string_literal: true

RSpec.describe 'Invalid form' do
  let(:options) { {} }
  let(:registration_form) { RegistrationForm.new(args) }
  let(:args) do
    { name: '1234' }
  end

  before do
    expect(registration_form.user).to be_valid
    expect(registration_form).to_not be_valid
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
        expect { subject }.to change { User.last&.name }.to '1234'
      end
    end
  end

  describe '#save!' do
    subject { registration_form.save!(options) }

    it 'raises an exception' do
      expect { subject }.to raise_error(ActiveRecord::RecordNotSaved)
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
        expect { subject }.to change { User.last&.name }.to '1234'
      end
    end
  end
end
