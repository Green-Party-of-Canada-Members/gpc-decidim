# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/participatory_processes/participatory_processes/show",
                     name: "remove_pp_column_size_class",
                     set_attributes: ".columns.medium-7.mediumlarge-8",
                     attributes: { class: 'columns<%= " medium-7 mediumlarge-8" unless leadership_race_process?(current_participatory_space) %>' })
