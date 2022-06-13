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
      # layouts
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440",
      # cells
      "/app/cells/decidim/date/show.erb" => "7e050b942e447386fc96ef6528039cec"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      "/app/views/decidim/meetings/meetings/show.html.erb" => "f10b79ff2fbb714470fd7eef6f3a0056",
      "/app/cells/decidim/meetings/meeting_m/single_date.erb" => "d7bb73188f6c1299c926bafa59aedc24"
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
