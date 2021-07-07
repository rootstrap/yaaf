# frozen_string_literal: true

RSpec.describe 'Callback Exceptions' do
  let(:options) { {} }
  let(:args) do
    {
      email: 'steve@example.com',
      name: 'Steve Rogers',
      comment: comment
    }
  end
  let(:form) { WithCallbackFormSaving.new(args) }

  describe '#save' do
    subject { form.save(options) }

    context 'when the callback object is valid' do
      let(:comment) { 'Avengers, Assemble!' }

      it 'saves the model and callback object' do
        expect { subject }
          .to change { User.count }
          .by(1)
          .and change { Comment.count }
          .by(1)
      end
    end

    context 'when the callback object is not valid' do
      let(:comment) { '' }

      it 'does not save the model or the callback object' do
        expect { subject }
          .to change { User.count }
          .by(0)
          .and change { Comment.count }
          .by(0)
      end

      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end

  describe '#save!' do
    subject { form.save!(options) }

    context 'when the after_save callback object is valid' do
      let(:comment) { 'Avengers, Assemble!' }

      it 'saves the model and callback object' do
        expect { subject }
          .to change { User.count }
          .by(1)
          .and change { Comment.count }
          .by(1)
      end
    end

    context 'when the callback object is not valid' do
      let(:comment) { '' }

      it 'raises an exception' do
        expect { subject }.to raise_exception(ActiveRecord::RecordInvalid)
      end
    end
  end
end
