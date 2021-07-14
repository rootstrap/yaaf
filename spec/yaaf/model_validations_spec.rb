# frozen_string_literal: true

RSpec.describe 'Model validations' do
  let(:form) { WithValidationCallbacksForm.new(args) }
  let(:email) { 'test@example.com' }
  let(:name) { 'John' }
  let(:args) do
    { email: email, name: name, before_counter: 0, after_counter: 0 }
  end

  context 'by default' do
    let(:options) { {} }

    %i[save save!].each do |persistence_method|
      it "calling #{persistence_method} runs the model validations only once" do
        expect(form.user).to receive(:custom_validation).once

        form.send(persistence_method, options)
      end
    end
  end

  context 'with validate: false' do
    let(:options) { { validate: false } }

    %i[save save!].each do |persistence_method|
      it "calling #{persistence_method} doesn't run model validations" do
        expect(form.user).not_to receive(:custom_validation)

        form.send(persistence_method, options)
      end
    end
  end
end
