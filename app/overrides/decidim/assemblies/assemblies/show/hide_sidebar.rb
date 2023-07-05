# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/assemblies/assemblies/show",
                     name: "hide_sidebar",
                     set_attributes: ".section.columns.medium-5.mediumlarge-4.large-3",
                     attributes: { style: '<%= "display:none" if leadership_assembly?(current_participatory_space, parents: false) %>' })
