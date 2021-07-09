# frozen_string_literal: true

RSpec.describe 'Callback Exceptions' do
  RESCUEABLE_EXCEPTIONS = [
    ActiveRecord::RecordInvalid,
    ActiveRecord::RecordNotSaved,
    ActiveModel::ValidationError
  ].freeze

  let(:options) { {} }
  let(:args) { {} }
  let(:form) do
    WithCallbackExceptionRaising.new(args)
  end

  describe '#save' do
    subject { form.save(options) }

    context 'without a callback exception raised' do
      it 'saves the model' do
        expect { subject }
          .to change { User.count }
          .by(1)
      end

      it 'returns true' do
        expect(subject).to eq true
      end
    end

    context 'with a rescueable exception' do
      RESCUEABLE_EXCEPTIONS.each do |exception|
        context "when an #{exception} is raised" do
          let(:args) do
            {
              callback_exception: exception
            }
          end

          it 'does not save the model' do
            expect { subject }
              .to change { User.count }
              .by(0)
          end

          it 'returns false' do
            expect(subject).to eq false
          end
        end
      end
    end

    context 'with a non-rescuable exception' do
      let(:exception) { ActiveRecord::NotNullViolation }
      let(:args) do
        {
          callback_exception: exception
        }
      end

      it 'does not save the model' do
        expect { subject rescue nil }
          .to change { User.count }
          .by(0)
      end

      it 'raises the exception' do
        expect { subject }.to raise_exception(exception)
      end
    end
  end

  describe '#save!' do
    subject { form.save!(options) }

    context 'without a callback exception raised' do
      it 'saves the model' do
        expect { subject }
          .to change { User.count }
          .by(1)
      end

      it 'returns true' do
        expect(subject).to eq true
      end
    end

    context 'with a rescueable exception' do
      RESCUEABLE_EXCEPTIONS.each do |exception|
        context "when an #{exception} is raised" do
          let(:args) do
            {
              callback_exception: exception
            }
          end

          it 'does not save the model' do
            expect { subject rescue nil }
              .to change { User.count }
              .by(0)
          end

          it 'raises the exception' do
            expect { subject }.to raise_exception(exception)
          end
        end
      end
    end

    context 'with a non-rescueable exception' do
      let(:exception) { ActiveRecord::NotNullViolation }
      let(:args) do
        {
          callback_exception: exception
        }
      end

      it 'does not save the model' do
        expect { subject rescue nil }
          .to change { User.count }
          .by(0)
      end

      it 'raises the exception' do
        expect { subject }.to raise_exception(exception)
      end
    end
  end
end
