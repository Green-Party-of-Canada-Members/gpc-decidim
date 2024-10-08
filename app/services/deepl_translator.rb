# frozen_string_literal: true

class DeeplTranslator
  attr_reader :text, :source_locale, :target_locale, :resource, :field_name

  def initialize(resource, field_name, text, target_locale, source_locale)
    @resource = resource
    @field_name = field_name
    @text = text
    @target_locale = target_locale
    @source_locale = source_locale
  end

  def translate
    translation = DeepL.translate(text, source_locale, target_locale, tag_handling:)

    Decidim::MachineTranslationSaveJob.perform_later(
      resource,
      field_name,
      target_locale,
      translation.text
    )
  end

  def tag_handling
    "html" if organization&.rich_text_editor_in_public_views
  end

  def organization
    resource.try(:organization) || resource.try(:participatory_space).try(:organization) || resource.try(:component).try(:organization)
  end
end
