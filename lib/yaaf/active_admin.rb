# frozen_string_literal: true

module YAAF
  module ActiveAdmin
    extend ActiveSupport::Concern

    included do
      after_validation :sanitize_errors

      delegate_missing_to :main_model

      def self.reflect_on_association(*args)
        main_model_class.reflect_on_association(*args)
      end

      private

      def sanitize_errors
        form_attributes_validations = self.class.validators.map(&:attributes).flatten
        form_attributes_validations.each do |form_attributes_validation|
          message = errors.messages[form_attributes_validation]
          errors.add(:base, message) if message.present?
        end
      end

      def main_model
        models.first
      end
    end
  end
end
