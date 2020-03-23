# frozen_string_literal: true

module YAAF
  # Parent class for form objects
  class Form
    include ::ActiveModel::Model
    include ::ActiveModel::Validations::Callbacks
    define_model_callbacks :save
    define_model_callbacks :commit, only: :after

    validate :validate_models

    def save(options = {})
      unless options[:validate] == false
        return false if invalid?
      end

      run_callbacks :commit do
        save_in_transaction(options)
      end

      true
    end

    def save!(options = {})
      save(options) || raise(ActiveRecord::RecordNotSaved.new('Failed to save the form', self))
    end

    private

    attr_accessor :models

    def promote_errors(model)
      model.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end

    def save_in_transaction(options)
      ::ActiveRecord::Base.transaction do
        run_callbacks :save do
          models.map { |model| model.save!(options) }
        end
      end
    end

    def validate_models
      models.each do |model|
        promote_errors(model) if model.invalid?
      end
    end
  end
end
