# frozen_string_literal: true

module YAAF
  # Parent class for form objects
  class Form
    include ::ActiveModel::Model
    include ::ActiveModel::Validations::Callbacks
    include ::ActiveRecord::Transactions
    define_model_callbacks :save

    delegate :transaction, to: ::ActiveRecord::Base

    validate :validate_models

    def save(options = {})
      save_form(options)
    rescue ActiveRecord::RecordInvalid,
           ActiveRecord::RecordNotSaved,
           ActiveModel::ValidationError

      false
    end

    def save!(options = {})
      save_form(options)
    end

    private

    attr_accessor :models

    def save_form(options)
      validate! unless options[:validate] == false

      run_callbacks :commit do
        save_in_transaction(options)
      end

      true
    end

    def save_in_transaction(options)
      transaction do
        run_callbacks :save do
          save_models(options)
        end
      end
    rescue Exception => e
      handle_transaction_rollback(e)
    end

    def save_models(options)
      models.map { |model| model.save!(options) }
    end

    def validate_models
      models.each { |model| promote_errors(model) if model.invalid? }
    end

    def promote_errors(model)
      errors.merge!(model.errors)
    end

    def handle_transaction_rollback(exception)
      run_callbacks :rollback
      raise exception
    end
  end
end
