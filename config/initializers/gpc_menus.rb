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
  process = Rails.application.secrets.dig(:gpc, :processes, :policy_process)
  space = Rails.application.secrets.dig(:gpc, :assemblies, :leadership)
  watch_race = Rails.application.secrets.dig(:gpc, :live, :watch_race)
  # custom processes menus
  if race
    Decidim.menu :menu do |menu|
      menu.add_item :leadership_race,
                    I18n.t("gpc.leadership_race"),
                    decidim_participatory_processes.participatory_process_path(race),
                    position: 2,
                    if: Decidim::ParticipatoryProcess.where(organization: current_organization).published.any?,
                    active: :inclusive
    end
  end

  if process
    Decidim.menu :menu do |menu|
      menu.add_item :policy_process,
                    I18n.t("gpc.policy_process"),
                    decidim_participatory_processes.participatory_process_path(process),
                    position: 6,
                    if: Decidim::ParticipatoryProcess.where(organization: current_organization).published.any?,
                    active: :inclusive
    end
  end

  if space
    Decidim.menu :menu do |menu|
      menu.add_item :leadership,
                    I18n.t("gpc.leadership_campaigns"),
                    decidim_assemblies.assembly_path(space),
                    position: 2.1,
                    if: Decidim::Assemblies::OrganizationPublishedAssemblies.new(current_organization, current_user).any?,
                    active: leadership_assembly?(Decidim::Assembly.find_by(slug: params[:slug]))
    end
  end

  if watch_race
    Decidim.menu :menu do |menu|
      menu.remove_item :root
      menu.add_item :watch_race,
                    (I18n.t("static.watch_race.title") + image_pack_tag("media/images/live-on-air.png")).html_safe,
                    Rails.application.routes.url_helpers.watch_race_static_path,
                    position: 1.1,
                    active: :inclusive
    end
  end
end
