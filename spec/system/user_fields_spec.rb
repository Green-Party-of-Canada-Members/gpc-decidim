# frozen_string_literal: true

require "rails_helper"

describe "Visit the signup page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }

  before do
    switch_to_host(organization.host)
  end

  it "renders the Sign up page" do
    visit decidim.new_user_registration_path
    expect(page).to have_content("Sign up")
    expect(page).to have_content("Your name")
    expect(page).to have_content("Nickname")
    expect(page).to have_content("Your email")
    expect(page).to have_content("Date of birth")
    expect(page).to have_content("Gender")
    expect(page).to have_content("Country")
    expect(page).to have_content("Postal code")
    expect(page).to have_content("Password")
    expect(page).to have_content("Terms of Service")
    expect(page).to have_content("Contact permission")
  end
end
