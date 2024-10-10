# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/participatory_processes/participatory_processes/show",
                     name: "hide_pp_sidebar",
                     set_attributes: ".section.columns.medium-5.mediumlarge-4.large-3",
                     attributes: { style: '<%= "display:none" if leadership_race_process?(current_participatory_space) %>' })
