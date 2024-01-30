# frozen_string_literal: true

require "rails_helper"

describe "Custom proposals fields", type: :system, versioning: true do
  let(:organization) { create :organization }
  let(:participatory_process) do
    create(:participatory_process, :with_steps, organization: organization)
  end

  let(:component) do
    create(:proposal_component,
           participatory_space: participatory_process, settings: settings, step_settings: step_settings)
  end
  let(:active_step_id) { participatory_process.active_step.id }
  let(:step_settings) { { active_step_id => { amendment_creation_enabled: amendment_creation_enabled, amendments_visibility: visibility } } }
  let(:visibility) { "all" }
  let(:settings) { { amendments_enabled: amendments_enabled, limit_pending_amendments: limit_pending_amendments } }
  let(:creator) { create(:user, :confirmed, organization: organization) }
  let(:user) { create(:user, :confirmed, organization: organization) }
  let(:follower) { create(:user, :confirmed, organization: organization) }
  let!(:follow) { create :follow, user: follower, followable: proposal }

  let!(:proposal) { create :proposal, users: [creator], component: component }
  let!(:emendation) { create(:proposal, title: { en: "An emendation for the proposal" }, component: component) }
  let!(:amendment) { create(:amendment, amendable: proposal, emendation: emendation, state: amendment_state) }

  let(:amendment_state) { "evaluating" }
  let(:limit_pending_amendments) { true }
  let(:amendments_enabled) { true }
  let(:amendment_creation_enabled) { true }
  let(:logged_user) { user }

  before do
    switch_to_host(organization.host)
    login_as logged_user, scope: :user
    visit_component
    click_link proposal.title["en"]
  end

  def visit_component
    page.visit main_component_path(component)
  end

  def amendment_path
    Decidim::ResourceLocatorPresenter.new(proposal.amendment.emendation).path
  end

  context "when there's pending amendments" do
    it "cannot create a new one" do
      expect(page).to have_content(proposal.title["en"])
      expect(page).to have_content(emendation.title["en"])
      click_link "Amend"

      within ".limit_amendments_modal" do
        expect(page).to have_link(href: amendment_path)
        expect(page).to have_content("Currently, there's another amendment being evaluated for this proposal.")
        # TODO: check text with "follow" to be notified is present
      end
    end
  end

  context "when logged is the author" do
    let(:logged_user) { creator }

    it "can be accepted" do
      click_link "An emendation for the proposal"
      click_link "Accept"
      perform_enqueued_jobs do
        click_button "Accept amendment"
      end

      # TODO: check authors have received emails as creators
      # todo: check followers have received emails as followers (if not already creators)
      expect(page).to have_content("The amendment has been accepted successfully")
    end

    it "can be rejected" do
      # todo
    end
  end
end
