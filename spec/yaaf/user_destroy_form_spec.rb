# frozen_string_literal: true

RSpec.describe 'UserDestroyForm form' do
  let(:user_destroy_form) { UserDestroyForm.new(args) }
  let(:args) do
    { email: 'test@example.com', name: 'John' }
  end
  let(:user_args) { args }
  let!(:user) { User.create(user_args) }

  describe '#save' do
    subject { user_destroy_form.save }

    context 'when the user exists' do
      before do
        expect(user_destroy_form).to be_valid
      end

      it 'returns true' do
        expect(subject).to eq true
      end

      it 'deletes the user' do
        expect { subject }.to change { User.count }.by(-1)
      end
    end

    context 'when the user doesn\'t exist' do
      let(:user_args) do
        { email: 'another@email.com', name: 'John' }
      end

      it 'returns false' do
        expect(subject).to eq false
      end

      it 'doesn\'t delete the user' do
        expect { subject }.not_to change { User.count }
      end
    end
  end

  describe '#save!' do
    subject { user_destroy_form.save! }

    context 'when the user exists' do
      before do
        expect(user_destroy_form).to be_valid
      end

      it 'returns true' do
        expect(subject).to eq true
      end

      it 'deletes the user' do
        expect { subject }.to change { User.count }.by(-1)
      end
    end

    context 'when the user doesn\'t exist' do
      let(:user_args) do
        { email: 'another@email.com', name: 'John' }
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(ActiveModel::ValidationError)
      end

      it 'doesn\'t delete the user' do
        expect { subject rescue nil }.not_to change { User.count }
      end
    end
  end

  describe '#valid?' do
    subject { user_destroy_form.valid? }

    it { is_expected.to be true }
  end

  describe '#invalid?' do
    subject { user_destroy_form.invalid? }

    it { is_expected.to be false }
  end

  describe '#errors' do
    subject do
      user_destroy_form.valid?
      user_destroy_form.errors
    end

    it 'returns the correct class' do
      expect(subject.class).to eq(ActiveModel::Errors)
    end

    it 'is empty' do
      expect(subject.messages).to be_empty
    end
  end
end
