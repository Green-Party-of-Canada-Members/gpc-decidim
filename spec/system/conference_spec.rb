# frozen_string_literal: true

require "rails_helper"

describe "Visit a conference", type: :system do
  let(:organization) { create :organization }
  let(:conference) { create :conference, slug: slug, registrations_enabled: registrations_enabled, organization: organization }
  let(:registrations_enabled) { true }
  let(:slug) { "my-conference" }
  let(:conference_env) { "CONFERENCE_#{slug.gsub("-", "_").upcase}_REGISTRATION" }
  let(:external_path) { "https://example.org" }
  let(:compare_path) { external_path }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with(conference_env, nil).and_return(external_path)
    switch_to_host(organization.host)
    visit decidim_conferences.conference_path(conference)
  end

  shared_examples "external links" do
    it "has a link to external site" do
      expect(page).to have_link("Register", href: compare_path, count: 3)
      expect(page).not_to have_link("Register", href: decidim_conferences.conference_registration_types_path(conference))
    end
  end

  shared_examples "internal links" do
    it "has the internal link" do
      expect(page).to have_link("Register", href: decidim_conferences.conference_registration_types_path(conference), count: 2)
      expect(page).not_to have_link("Register", href: compare_path)
    end
  end

  shared_examples "no links" do
    it "has no registration" do
      expect(page).not_to have_link("Register")
    end
  end

  it_behaves_like "external links"

  context "when language interpolation" do
    let(:external_path) { "https://example.org/%{locale}" }
    let(:compare_path) { "https://example.org/#{I18n.locale}" }

    it_behaves_like "external links"
  end

  context "when registrations not enabled" do
    let(:registrations_enabled) { false }

    it_behaves_like "external links"
  end

  context "when no path" do
    let(:external_path) { "" }

    it_behaves_like "internal links"

    context "when registrations not enabled" do
      let(:registrations_enabled) { false }

      it_behaves_like "no links"
    end
  end

  context "when no env" do
    let(:conference_env) { "CONFERENCE_OTHER_CONFERENCE_REGISTRATION" }

    it_behaves_like "internal links"

    context "when registrations not enabled" do
      let(:registrations_enabled) { false }

      it_behaves_like "no links"
    end
  end
end
