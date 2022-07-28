# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", versioning: true, type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:process) { create :participatory_process, show_statistics: false, organization: organization }
  let!(:component) { create(:proposal_component, participatory_space: process) }
  let!(:proposal) { create(:proposal, title: { en: "Original long enough title" }, body: { en: "Original one liner body" }, component: component) }
  # The first version of the emendation should hold the original proposal attribute values being amended.
  let!(:emendation) { create(:proposal, title: proposal.title, body: proposal.body, component: component) }
  let!(:amendment) { create :amendment, amendable: proposal, emendation: emendation }

  let(:emendation_path) { Decidim::ResourceLocatorPresenter.new(emendation).path }
  let(:proposal_path) { Decidim::ResourceLocatorPresenter.new(proposal).path }

  before do
    switch_to_host(organization.host)
  end

  it "renders the home page" do
    visit decidim.root_path
    expect(page).to have_content("Home")
  end

  it "renders all participatory processes" do
    visit decidim_participatory_processes.participatory_processes_path
    expect(page).to have_content("1 ACTIVE PROCESS")
  end

  it "renders a participatory process" do
    visit decidim_participatory_processes.participatory_process_path(process)

    expect(page).to have_content(process.title["en"])
    expect(page).to have_content("PROPOSALS")
    expect(page).to have_content(proposal.title["en"])
    expect(page).to have_content(emendation.title["en"])
  end

  it "renders a proposal" do
    visit proposal_path

    expect(page).to have_content(process.title["en"])
    expect(page).to have_content("AMENDED BY")
    expect(page).to have_content(emendation.authors.first.name)
  end

  it "renders an amendment" do
    visit emendation_path

    expect(page).to have_content(emendation.title["en"])
    expect(page).to have_content("Amendment to \"#{proposal.title["en"]}\"")
  end
end
