# frozen_string_literal: true

require "rails_helper"

describe "Visit the signup page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:user) { create :user, :admin, :confirmed, organization: organization }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin.root_path
  end

  it "renders the dashboard page" do
    expect(page).to have_content("Welcome to the Decidim Admin Panel")
  end

  it "renders the processes page" do
    click_link "Processes"
    within ".layout-content" do
      expect(page).to have_content("Participatory processes")
    end
  end

  it "renders the assemblies page" do
    click_link "Assemblies"
    within "#assemblies" do
      expect(page).to have_content("Assemblies")
      expect(page).to have_content("New assembly")
    end
  end

  it "renders global moderations" do
    click_link "Global moderations"
    within ".layout-content" do
      expect(page).to have_content("Moderations")
    end
  end

  it "renders pages" do
    click_link "Pages"
    within ".layout-content" do
      expect(page).to have_content("Pages")
    end
  end

  it "renders calendar" do
    click_link "Calendar"
    within ".layout-content" do
      expect(page).to have_content("External events")
    end
  end

  it "renders newsletters" do
    click_link "Newsletters"
    within ".layout-content" do
      expect(page).to have_content("Newsletters")
    end
  end

  it "renders settings" do
    click_link "Settings"
    within ".layout-content" do
      expect(page).to have_content("Edit organization")
    end
  end

  # it "renders analytics" do
  #   click_link "Analytics"
  #   within ".layout-content" do
  #     expect(page).to have_content("Analytics")
  #   end
  # end

  it "renders Decidim awesome" do
    click_link "Decidim awesome"
    within ".layout-content" do
      expect(page).to have_content("Tweaks for editors")
    end
  end

  it "renders admin activity log" do
    click_link "Admin activity log"
    within ".layout-content" do
      expect(page).to have_content("Admin log")
    end
  end

  it "renders templates" do
    click_link "Templates"
    within ".layout-content" do
      expect(page).to have_content("Templates")
    end
  end
end
