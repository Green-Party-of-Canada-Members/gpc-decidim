# frozen_string_literal: true

class StaticController < Decidim::ApplicationController
  def watch_race
    @iframe_url = Rails.application.secrets.dig(:gpc, :watch_race_iframe)
  end
end
