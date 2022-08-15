# frozen_string_literal: true

module ApplicationHelper
  def gpc_time_zone(value)
    "(#{value.zone} #{value.formatted_offset})"
  end

  def leadership_space?(space, parents: true)
    return false if space.blank?

    return true if space.slug == Rails.application.secrets.dig(:gpc, :leadership_space)

    parents ? leadership_space?(space.parent) : false
  end

  def donate_link(space)
    "https://www.greenparty.ca/en/civicrm/contribute/transact?id=1&source=L22.W.#{space.slug}"
  end
end
