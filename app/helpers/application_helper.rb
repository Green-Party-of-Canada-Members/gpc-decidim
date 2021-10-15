# frozen_string_literal: true

module ApplicationHelper
  def gpc_time_zone(value)
    "(#{value.zone} #{value.formatted_offset})"
  end
end
