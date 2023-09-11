# frozen_string_literal: true

module ApplicationHelper
  def gpc_time_zone(value)
    t("gpc.timezones.#{value.zone}", default: value.zone)
  end

  def gpc_time_format(value)
    (l value, format: "%l:%M %p").downcase
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
    contestants = Rails.application.secrets.dig(:gpc, :components, :contestants)
    return false if component.blank? || contestants.blank?

    return true if component.id.in?(contestants)
  end

  def show_donate_on_proposal?
    Rails.application.secrets.dig(:gpc, :always_show_donate_button)
  end

  def donate_link(name)
    "https://www.greenparty.ca/en/donations/#{name.strip.gsub(" ", ".")}-#{I18n.locale}"
  end

  def generic_donate_url
    @generic_donate_url ||= Rails.application.secrets.dig(:gpc, :donate_button).gsub("%{locale}", I18n.locale.to_s)
  end

  def generic_chat_url
    @generic_chat_url ||= Rails.application.secrets.dig(:gpc, :chat_button).gsub("%{locale}", I18n.locale.to_s)
  end

  def campaign_assembly_link(title)
    parent = Decidim::Assembly.find_by(slug: Rails.application.secrets.dig(:gpc, :assemblies, :leadership))
    return unless parent

    assembly = parent.children.find_by("title->>'en' = ? OR title->>'fr' = ?", title, title)
    return unless assembly

    decidim_assemblies.assembly_path(assembly.slug)
  end
end
