# frozen_string_literal: true

module CardMetadataCellOverride
  extend ActiveSupport::Concern

  included do
    private

    def start_date_item
      return if dates_blank?

      {
        text: gpc_time_format(start_date),
        icon: "time-line"
      }
    end
  end
end
