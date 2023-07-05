# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/proposals/proposals/_proposals",
                     name: "hide_proposals_withdrawn",
                     set_attributes: ".row .text-right",
                     attributes: { style: '<%= "display:none" if contestants_component?(current_component) %>' })
