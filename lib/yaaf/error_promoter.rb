# frozen_string_literal: true

module YAAF
  module ErrorPromoter
    def self.included(base)
      if legacy_promoter?
        base.include(LegacyPromoter)
      else
        base.include(CurrentPromoter)
      end
    end

    def self.legacy_promoter?
      ActiveModel::VERSION::MAJOR < 6 ||
        ActiveModel::VERSION::MAJOR == 6 && ActiveModel::VERSION::MINOR.zero?
    end

    module LegacyPromoter
      def promote_errors(model)
        model.errors.details.each do |attribute, details|
          details.each do |detail|
            options = detail.except(:error)

            errors.add(attribute, detail[:error], **options)
          end
        end
      end
    end

    module CurrentPromoter
      def promote_errors(model)
        model.errors.each do |model_error|
          errors.add(model_error.attribute, model_error.type, **model_error.options)
        end
      end
    end
  end
end
