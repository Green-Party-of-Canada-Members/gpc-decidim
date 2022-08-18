# frozen_string_literal: true

module ApplicationHelper
  def gpc_time_zone(value)
    "(#{value.zone} #{value.formatted_offset})"
  end

  def leadership_assembly?(space, parents: true)
    return false if space.blank? || !space.respond_to?(:slug)

    return true if space.slug == Rails.application.secrets.dig(:gpc, :assemblies, :leadership)

    parents ? leadership_assembly?(space.try(:parent)) : false
  end

  def leadership_race_process?(space)
    return false if space.blank? || !space.respond_to?(:slug)

    return true if space.slug == Rails.application.secrets.dig(:gpc, :processes, :leadership_race)
  end

  def contestants_component?(component)
    return false if component.blank?

    return true if component.id.in?(Rails.application.secrets.dig(:gpc, :proposals, :contestants))
  end

  def donate_link(id)
    "https://www.greenparty.ca/en/civicrm/contribute/transact?id=1&source=L22.W.#{id}"
  end

  def campaign_assembly_link(title)
    parent = Decidim::Assembly.find_by(slug: Rails.application.secrets.dig(:gpc, :assemblies, :leadership))
    return unless parent

    assembly = parent.children.find_by("title->>'en' = ? OR title->>'fr' = ?", title, title)
    return unless assembly

    decidim_assemblies.assembly_path(assembly.slug)
  end
end
