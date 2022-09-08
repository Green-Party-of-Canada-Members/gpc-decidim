# frozen_string_literal: true

# Awesome menu tweaker is not compatible with remove_item or custom "active" settings so we remove the feature
Decidim::DecidimAwesome.configure do |config|
  config.menu = :disabled
end

# Custom assembly menu for leaderships
Decidim.menu :menu do |menu|
  menu.remove_item :assemblies
  menu.remove_item :participatory_processes
  # menu.remove_item :calendar
end

Rails.application.config.after_initialize do
  Decidim::DecidimAwesome::Admin::MenuHacksController.include(ApplicationHelper) if defined?(Decidim::DecidimAwesome::Admin::MenuHacksController)

  race = Rails.application.secrets.dig(:gpc, :processes, :leadership_race)
  events = Rails.application.secrets.dig(:gpc, :assemblies, :leadership_events)
  process = Rails.application.secrets.dig(:gpc, :processes, :policy_process)
  space = Rails.application.secrets.dig(:gpc, :assemblies, :leadership)
  watch_race = Rails.application.secrets.dig(:gpc, :watch_race_iframe)
  redirect_homepage = Rails.application.secrets.dig(:gpc, :redirect_homepage)

  if redirect_homepage.present?
    Decidim.menu :menu do |menu|
      menu.remove_item :root
    end
  end

  # custom processes menus
  if race.present?
    Decidim.menu :menu do |menu|
      menu.add_item :leadership_race,
                    I18n.t("gpc.leadership_race"),
                    decidim_participatory_processes.participatory_process_path(race),
                    position: 2,
                    if: Decidim::ParticipatoryProcess.published.exists?(slug: race),
                    active: :inclusive
    end
  end

  if events.present?
    Decidim.menu :menu do |menu|
      menu.add_item :leadership_events,
                    I18n.t("gpc.leadership_events"),
                    decidim_assemblies.assembly_path(events),
                    position: 2.1,
                    if: Decidim::Assembly.published.exists?(slug: events),
                    active: :inclusive
    end
  end

  if process.present?
    Decidim.menu :menu do |menu|
      menu.add_item :policy_process,
                    I18n.t("gpc.policy_process"),
                    decidim_participatory_processes.participatory_process_path(process),
                    position: 6,
                    if: Decidim::ParticipatoryProcess.published.exists?(slug: process),
                    active: :inclusive
    end
  end

  if space.present?
    Decidim.menu :menu do |menu|
      menu.add_item :leadership,
                    I18n.t("gpc.leadership_campaigns"),
                    decidim_assemblies.assembly_path(space),
                    position: 2.1,
                    if: Decidim::Assembly.published.exists?(slug: space),
                    active: leadership_assembly?(Decidim::Assembly.find_by(slug: params[:slug]))
    end
  end

  if watch_race.present?
    Decidim.menu :menu do |menu|
      menu.add_item :watch_race,
                    (I18n.t("static.watch_race.title") + image_pack_tag("media/images/live-on-air.png")).html_safe,
                    Rails.application.routes.url_helpers.watch_race_static_path,
                    position: 1.1,
                    active: :inclusive
    end
  end
end
