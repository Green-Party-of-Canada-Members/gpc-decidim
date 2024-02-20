# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-comments",
    files: {
      "/app/cells/decidim/comments/comments_cell.rb" => "2189e89b4ca78b7e4300b1097d2296e5"
    }
  },
  {
    package: "decidim-core",
    files: {
      # controllers
      "/app/controllers/decidim/devise/omniauth_registrations_controller.rb" => "d2470bf88b509572affa7f225f6ee424",
      "/app/controllers/decidim/devise/registrations_controller.rb" => "f519953daa03df46b98d34b3311a17d0",
      "/app/controllers/decidim/devise/invitations_controller.rb" => "32ef1da80ec9dd20b884e5829c3307e6",
      # layouts
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440",
      "/app/views/decidim/devise/sessions/new.html.erb" => "9d090fc9e565ded80a9330d4e36e495c",
      "/app/views/decidim/devise/shared/_omniauth_buttons_mini.html.erb" => "d3a413ce7c64959eee3b912406075f84",
      # cells
      "/app/cells/decidim/date_range/show.erb" => "7e050b942e447386fc96ef6528039cec",
      "/app/cells/decidim/diff/attribute.erb" => "d648bc8e71e27c404d82132d6e3c3241",
      "/app/cells/decidim/diff/diff_mode_dropdown.erb" => "770563c121c875159a88cd5e142658e3",
      # other overrides
      "/app/helpers/decidim/card_helper.rb" => "b9e7f943ae7c289b2855d328de7b371b",
      "/app/commands/decidim/amendable/accept.rb" => "c561b69a7bd5b68dfc4684c11001cb2c",
      "/app/commands/decidim/amendable/reject.rb" => "efd7062b0942b0ec80e336345ffca62f"

    }
  },
  {
    package: "decidim-meetings",
    files: {
      "/app/controllers/decidim/meetings/admin/invites_controller.rb" => "2cf91718146e0223d7b7794f44d5d8c6",
      "/app/cells/decidim/meetings/meeting_m/single_date.erb" => "d7bb73188f6c1299c926bafa59aedc24",
      "/app/views/decidim/meetings/meetings/show.html.erb" => "69914b0ea3e30b47506bb254269fbd3d"
    }
  },
  {
    package: "decidim-debates",
    files: {
      "/app/cells/decidim/debates/debate_m/single_date.erb" => "d7bb73188f6c1299c926bafa59aedc24",
      "/app/cells/decidim/debates/debate_m/multiple_dates.erb" => "d56d9a5d2e37cf1a7c75974f6254db4f"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "eeabef769e29b59de98af16d3549dcab"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conferences/show.html.erb" => "94e3fb8ee4e092678ce0f229c87e1bc0",
      "/app/views/layouts/decidim/_conference_hero.html.erb" => "db2e565169a5ce7f8a3e7d03dd0ebfd9"
    }
  },
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "747ee665f0c08484436f320865df62cc"
    }
  },
  {
    package: "decidim-forms",
    files: {
      "/app/commands/decidim/forms/answer_questionnaire.rb" => "c53587b220467c2d6889f657ac2404a0"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/controllers/decidim/proposals/proposals_controller.rb" => "b263741e3335110fa0e37c488c777190",
      "/app/views/decidim/proposals/proposals/index.html.erb" => "48fbf7a8332f5f4c026b793e7922bdbc",
      "/app/views/decidim/proposals/proposals/show.html.erb" => "f27bbec257eb6da28dbdd07ac0a224a5",
      "/app/cells/decidim/proposals/highlighted_proposals_for_component_cell.rb" => "b8a9a1b573b2f888b293d10a7fab6577",
      "/app/views/decidim/proposals/proposals/_proposals.html.erb" => "a4057670154210aff98e5f206d0fdfc2",
      "/app/views/decidim/proposals/proposals/_wizard_aside.html.erb" => "45dc17085fabc549bee6474b8a3e79df",
      "/app/views/decidim/proposals/proposals/_filters.html.erb" => "ab4fe3f5b9237d786595374fbb6b729c"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    # rubocop:disable Rails/DynamicFindBy
    spec = ::Gem::Specification.find_by_name(item[:package])
    # rubocop:enable Rails/DynamicFindBy
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
