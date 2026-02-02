# frozen_string_literal: true

RSpec.describe 'Form with normalization' do
  if defined?(ActiveModel::Attributes::Normalization)
    let(:form) { WithNormalizeForm.new(args) }
    let(:args) { { email: '  TEST@Example.com  ', name: '  john doe  ' } }

    describe 'attribute normalization' do
      it 'normalizes email on assignment' do
        expect(form.email).to eq('test@example.com')
      end

      it 'normalizes name on assignment' do
        expect(form.name).to eq('John Doe')
      end
    end

    describe '#save' do
      subject { form.save }

      it 'saves with normalized values' do
        expect(subject).to be true
        expect(User.last.email).to eq('test@example.com')
        expect(User.last.name).to eq('John Doe')
      end
    end

    describe '#valid?' do
      it 'validates with normalized values' do
        expect(form.valid?).to be true
      end
    end

    context 'when updating attributes' do
      it 'normalizes new values' do
        form.email = '  test@example.com  '
        expect(form.email).to eq('test@example.com')
      end
    end

    context 'with nil values' do
      let(:args) { { email: nil, name: nil } }

      it 'does not normalize nil by default' do
        expect(form.email).to be_nil
        expect(form.name).to be_nil
      end
    end
  end
end
