# frozen_string_literal: true

module ProposalsControllerOverride
  extend ActiveSupport::Concern

  included do
    before_action only: [:index] do
      session[:proposals_filter_default_type] = params.dig(:filter, :type) if params.dig(:filter, :type).present?
    end

    alias_method :default_filter_origin_params, :default_filter_params

    def default_filter_params
      default_filter_origin_params.tap do |params|
        params[:type] = session[:proposals_filter_default_type] || "proposals"
      end
    end
  end
end
