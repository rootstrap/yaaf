# frozen_string_literal: true

module YAAF
  # Parent class for form objects
  class Form
    include ::ActiveModel::Model

    validate :validate_models

    def save(options = {})
      unless options[:validate] == false
        with_validation_callbacks do
          return false if invalid?
        end
      end

      save_in_transaction(options)

      after_commit

      true
    end

    def save!(options = {})
      save(options) || raise(ActiveRecord::RecordNotSaved.new('Failed to save the form', self))
    end

    private

    attr_accessor :models

    def after_commit; end

    def after_save; end

    def after_validation; end

    def before_save; end

    def before_validation; end

    def promote_errors(model)
      model.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end

    def save_in_transaction(options)
      ::ActiveRecord::Base.transaction do
        before_save

        models.map { |model| model.save!(options) }

        after_save
      end
    end

    def validate_models
      models.each do |model|
        promote_errors(model) if model.invalid?
      end
    end

    def with_validation_callbacks
      before_validation
      yield
      after_validation
    end
  end
end
