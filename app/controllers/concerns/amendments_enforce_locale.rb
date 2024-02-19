# frozen_string_literal: true

module AmendmentsEnforceLocale
  extend ActiveSupport::Concern

  included do
    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :enforce_locale, only: [:new, :create]
    # rubocop:enable Rails/LexicallyScopedActionFilter

    def enforce_locale
      return unless amendable.component.settings.try(:amendments_enabled)
      return unless amendable.component.current_settings.try(:amendment_creation_enabled)
      return unless Rails.application.secrets.enforce_original_amendments_locale

      amendable_locale = amendable.title.keys.first
      return if current_locale.to_s == amendable_locale

      flash[:alert] = I18n.t("gpc.amendments.enforced_locale", lang: I18n.t("locale.name", locale: amendable_locale))
      redirect_to new_amend_path(amendable_gid: amendable_gid, locale: amendable.title.keys.first)
    end
  end
end
