# frozen_string_literal: true

module ProposalsControllerOverride
  extend ActiveSupport::Concern

  # included do
  #   before_action only: [:index] do
  #     session[:proposals_filter_default_type] = params.dig(:filter, :type) if params.dig(:filter, :type).present?
  #   end

  #   def default_filter_params
  #     {
  #       search_text_cont: "",
  #       with_any_origin: default_filter_origin_params,
  #       activity: "all",
  #       with_any_category: default_filter_category_params,
  #       with_any_state: %w(accepted evaluating state_not_published),
  #       with_any_scope: default_filter_scope_params,
  #       related_to: "",
  #       type: session[:proposals_filter_default_type] || "proposals"
  #     }
  #   end
  # end
end
