# frozen_string_literal: true

require "deepl"

class DeeplTranslator
  attr_reader :text, :source_locale, :target_locale, :resource, :field_name

  def initialize(resource, field_name, text, target_locale, source_locale)
    @resource = resource
    @field_name = field_name
    @text = text
    @target_locale = target_locale
    @source_locale = source_locale

    setup_deepl
  end

  def translate
    translation = DeepL.translate text, source_locale, target_locale

    Decidim::MachineTranslationSaveJob.perform_now(
      resource,
      field_name,
      target_locale,
      translation.text
    )
  end

  private

  def setup_deepl
    DeepL.configure do |config|
      config.auth_key = Rails.application.secrets.translator[:api_key]
      config.host = Rails.application.secrets.translator[:host]
    end
  end
end
