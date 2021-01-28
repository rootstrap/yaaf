# frozen_string_literal: true

module YAAF
  # Parent class for form objects
  class Form
    include ::ActiveModel::Model
    include ::ActiveModel::Validations::Callbacks
    include ::ActiveRecord::Transactions
    define_model_callbacks :save

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

    # :reek:DuplicateMethodCall
    def promote_errors(model)
      if rails_version_less_than_6_1?
        model.errors.each do |attribute, message|
          errors.add(attribute, message)
        end
      else
        model.errors.each do |model_error|
          errors.add(model_error.attribute, model_error.message)
        end
      end
    end

    def save_in_transaction(options)
      ::ActiveRecord::Base.transaction do
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
      models.each do |model|
        promote_errors(model) if model.invalid?
      end
    end

    def handle_transaction_rollback(exception)
      run_callbacks :rollback
      raise exception
    end

    def rails_version_less_than_6_1?
      ActiveModel::VERSION::MAJOR < 6 ||
        ActiveModel::VERSION::MAJOR == 6 && ActiveModel::VERSION::MINOR.zero?
    end
  end
end
