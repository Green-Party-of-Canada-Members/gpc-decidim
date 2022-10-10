# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # controllers
      "/app/controllers/decidim/devise/omniauth_registrations_controller.rb" => "05bc35af4b5f855736f14efbd22e439b",
      "/app/controllers/decidim/devise/registrations_controller.rb" => "0bd735750a5be12a2a0bf41a774248ad",
      "/app/controllers/decidim/devise/invitations_controller.rb" => "faa5403c358f686a87eea2d9f4eaf1d4",
      # layouts
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440",
      "/app/views/decidim/devise/sessions/new.html.erb" => "1da8569a34bcd014ffb5323c96391837",
      "/app/views/decidim/devise/shared/_omniauth_buttons_mini.html.erb" => "d3a413ce7c64959eee3b912406075f84",
      # cells
      "/app/cells/decidim/date_range/show.erb" => "7e050b942e447386fc96ef6528039cec",
      # other overrides
      "/app/helpers/decidim/card_helper.rb" => "b9e7f943ae7c289b2855d328de7b371b"

    }
  },
  {
    package: "decidim-meetings",
    files: {
      "/app/controllers/decidim/meetings/admin/invites_controller.rb" => "2cf91718146e0223d7b7794f44d5d8c6",
      "/app/cells/decidim/meetings/meeting_m/single_date.erb" => "d7bb73188f6c1299c926bafa59aedc24",
      "/app/views/decidim/meetings/meetings/show.html.erb" => "d0f2ec43188acab470151f40294bdbc8"
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
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "f409a2c1cc8383d769cc37b329cf616c"
    }
  },
  {
    package: "decidim-forms",
    files: {
      "/app/commands/decidim/forms/answer_questionnaire.rb" => "e935b815a42f7f57815a4c70e098580f"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/views/decidim/proposals/proposals/index.html.erb" => "48fbf7a8332f5f4c026b793e7922bdbc",
      "/app/views/decidim/proposals/proposals/show.html.erb" => "f27bbec257eb6da28dbdd07ac0a224a5",
      "/app/cells/decidim/proposals/highlighted_proposals_for_component_cell.rb" => "de95bcb5d3eecf93244c3f566a29fc6d",
      "/app/views/decidim/proposals/proposals/_proposals.html.erb" => "c080ee4886c7fa162dc198f43b068e33"
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
