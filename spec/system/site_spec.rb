# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", versioning: true, type: :system, perform_enqueued: true do
  include_context "with a component"

  let(:organization) { create :organization }
  let(:process) { create :participatory_process, show_statistics: false, organization: organization }
  let!(:component) { create(:proposal_component, participatory_space: process) }
  let!(:component2) { create(:meeting_component, participatory_space: process) }
  let!(:proposal) { create(:proposal, title: { en: "Original long enough title" }, body: { en: "Original one liner body" }, component: component) }
  let!(:meeting) { create(:meeting, :published, title: { en: "Boring long enough title" }, description: { en: "Boring one liner body" }, component: component2) }
  # The first version of the emendation should hold the original proposal attribute values being amended.
  let!(:emendation) { create(:proposal, title: proposal.title, body: proposal.body, component: component) }
  let!(:amendment) { create :amendment, amendable: proposal, emendation: emendation }

  let(:emendation_path) { Decidim::ResourceLocatorPresenter.new(emendation).path }
  let(:proposal_path) { Decidim::ResourceLocatorPresenter.new(proposal).path }
  let(:meeting_path) { Decidim::ResourceLocatorPresenter.new(meeting).path }

  before do
    switch_to_host(organization.host)
  end

  it "renders the home page" do
    visit decidim.root_path
    expect(page).to have_content("Home")
  end

  it "renders all participatory processes" do
    visit decidim_participatory_processes.participatory_processes_path
    expect(page).to have_content("2 ACTIVE PROCESSES")
  end

  it "renders a participatory process" do
    visit_component
    click_link "Proposals"

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

  it "renders a meeting" do
    visit meeting_path

    expect(page).to have_content(process.title["en"])
    expect(page).to have_content(meeting.title["en"])
  end

  it "renders an amendment" do
    visit emendation_path

    expect(page).to have_content(emendation.title["en"])
    expect(page).to have_content("Amendment to \"#{proposal.title["en"]}\"")
  end

  describe "default 50 per page" do
    %w(Proposals Meetings).each do |component|
      it "renders a list of 50 #{component}" do
        visit_component
        click_link component

        expect(page).to have_css('a[title="Select number of results per page"]', text: "50")
      end
    end
  end

  describe "comments sorting" do
    let(:author) { create(:user, :confirmed, organization: organization) }
    let(:comments) { create_list(:comment, 3, commentable: commentable) }
    let(:commentable) { create(:proposal, component: component, users: [author]) }

    before do
      visit resource_locator(commentable).path
    end

    it "renders a list of comments are sorted by recent" do
      visit resource_locator(commentable).path

      expect(page).to have_css("#comments-order-menu-control", text: "Recent")
    end

    it "saves the sorting to a cookie" do
      click_link "Recent"
      click_link "Older"
      sleep 1
      visit current_path

      expect(page).to have_css("#comments-order-menu-control", text: "Older")
    end
  end
end
