# frozen_string_literal: true

RSpec.describe YAAF::Form do
  class TestForm < YAAF::Form
    attr_accessor :name

    validates :name, format: { with: /[a-zA-Z]+/ }

    def initialize(args)
      super(args)

      @models = [User.new(name: name)]
    end
  end

  describe '#save' do
    let(:options) { {} }
    subject { TestForm.new(args).save(options) }

    context 'with valid values' do
      let(:args) do
        { name: 'John' }
      end

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

    context 'when the model is invalid' do
      let(:args) do
        { name: nil }
      end

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

          expect(User.last.name).to eq nil
        end
      end
    end

    context 'when the form is invalid' do
      let(:args) do
        { name: '1234' }
      end

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
  end

  describe '#save!' do
    let(:options) { {} }
    subject { TestForm.new(args).save!(options) }

    context 'with valid values' do
      let(:args) do
        { name: 'John' }
      end

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

    context 'when the model is invalid' do
      let(:args) do
        { name: nil }
      end

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
          subject

          expect(User.last.name).to eq nil
        end
      end
    end

    context 'when the form is invalid' do
      let(:args) do
        { name: '1234' }
      end

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
end
