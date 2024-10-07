# frozen_string_literal: true

require "rails_helper"

describe "Admin" do
  context "when admin access to dashboard" do
    let(:organization) { create(:organization) }
    let!(:user) { create(:user, :confirmed, organization:) }
    let!(:admin) { create(:user, :admin, :confirmed, organization:) }
    let(:url) { "http://example.org" }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ADMIN_IFRAME_URL", nil).and_return(url)
      switch_to_host(organization.host)
      login_as admin, scope: :user

      visit decidim_admin.root_path
    end

    it "displays custom iframe in the admin menu" do
      click_on "Plausible Stats")
      within ".layout-content" do
        expect(page).to have_content("Plausible Stats")
        expect(page).to have_css("iframe[src='#{url}']")
      end
    end

    context "when no url is set" do
      let(:url) { nil }

      it "does not display custom iframe in the admin menu" do
        expect(page).to have_no_content("Plausible Stats")")
      end
    end
  end
end
