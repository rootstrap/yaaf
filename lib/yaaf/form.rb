# frozen_string_literal: true

module YAAF
  # Parent class for form objects
  class Form
    include ::ActiveModel::Model

    validate :validate_models

    def save
      before_validation
      return false if invalid?

      save_in_transaction
      after_commit
      true
    end

    def after_commit; end

    def after_save; end

    def before_save; end

    def before_validation; end

    private

    attr_accessor :models

    def promote_errors(model)
      model.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end

    def save_in_transaction
      ::ActiveRecord::Base.transaction do
        before_save

        (models || []).map(&:save!)

        after_save
      end
    end

    def validate_models
      (models || []).each do |model|
        promote_errors(model) if model.invalid?
      end
    end
  end
end
