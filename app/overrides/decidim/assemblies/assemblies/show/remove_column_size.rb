# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/assemblies/assemblies/show",
                     name: "remove_column_size_class",
                     set_attributes: ".columns.medium-7.mediumlarge-8",
                     attributes: { class: 'columns<%= " medium-7 mediumlarge-8" unless leadership_assembly?(current_participatory_space, parents: false) %>' })
