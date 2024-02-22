# frozen_string_literal: true

module AmendmentsEnforceLocale
  extend ActiveSupport::Concern

  included do
    # rubocop:disable Rails/LexicallyScopedActionFilter
    around_action :enforce_amendment_locale, except: [:reject, :accept, :withdraw]
    # rubocop:enable Rails/LexicallyScopedActionFilter

    def enforce_amendment_locale(&action)
      if amendable.component.settings.try(:amendments_enabled) &&
         amendable.component.current_settings.try(:amendment_creation_enabled) &&
         !amendable&.official? &&
         Rails.application.secrets.gpc[:enforce_original_amendments_locale]
        amendable_locale = amendable.title.keys.first

        flash[:alert] = I18n.t("gpc.amendments.enforced_locale", lang: I18n.t("locale.name", locale: amendable_locale)) if current_locale.to_s != amendable_locale

        I18n.with_locale(amendable_locale, &action)
      else
        action.call
      end
    end
  end
end
