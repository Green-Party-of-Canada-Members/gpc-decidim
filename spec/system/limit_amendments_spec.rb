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
  let(:amender) { create(:user, :confirmed, organization: organization) }
  let(:follower) { create(:user, :confirmed, organization: organization) }
  let!(:follow) { create :follow, user: follower, followable: proposal }

  let!(:proposal) { create :proposal, users: [creator], component: component }
  let!(:emendation) { create(:proposal, users: [amender], title: { en: "An emendation for the proposal" }, component: component) }
  let!(:amendment) { create(:amendment, amendable: proposal, emendation: emendation, state: amendment_state) }

  let(:amendment_state) { "evaluating" }
  let(:limit_pending_amendments) { true }
  let(:amendments_enabled) { true }
  let(:amendment_creation_enabled) { true }
  let(:logged_user) { user }
  let(:enforce_locale) { true }

  before do
    allow(Rails.application.secrets).to receive(:enforce_original_amendments_locale).and_return(enforce_locale)
    switch_to_host(organization.host)
    login_as logged_user, scope: :user
    visit_component
  end

  def visit_component
    page.visit main_component_path(component)
  end

  def amendment_path
    Decidim::ResourceLocatorPresenter.new(proposal.amendment.emendation).path
  end

  context "when there's pending amendments" do
    it "cannot create a new one" do
      click_link proposal.title["en"]
      expect(page).to have_content(proposal.title["en"])
      expect(page).to have_content(emendation.title["en"])
      click_link "Amend"

      within ".limit_amendments_modal" do
        expect(page).to have_link(href: amendment_path)
        expect(page).to have_content("Currently, there's another amendment being evaluated for this proposal.")
        expect(page).to have_content("You can also be notified when the current amendment is accepted or rejected")
      end
    end
  end

  context "when logged is the author" do
    let(:logged_user) { creator }

    it "can be accepted" do
      click_link proposal.title["en"]
      click_link "An emendation for the proposal"
      click_link "Accept"
      perform_enqueued_jobs do
        click_button "Accept amendment"
      end

      emails.each do |email|
        expect(email.subject).to have_content("Accepted amendment for")
        case email.to.first
        when follower.email
          expect(email.text_part.to_s).to have_content("If you are planning to make an amendment yourself")
        else
          expect(email.text_part.to_s).not_to have_content("If you are planning to make an amendment yourself")
        end
      end
      expect(page).to have_content("The amendment has been accepted successfully")
    end

    it "can be rejected" do
      click_link proposal.title["en"]
      click_link "An emendation for the proposal"
      perform_enqueued_jobs do
        click_link "Reject"
      end

      emails.each do |email|
        expect(email.subject).to have_content("Amendment rejected for")
        case email.to.first
        when follower.email
          expect(email.text_part.to_s).to have_content("planning to make an amendment yourself")
        else
          expect(email.text_part.to_s).not_to have_content("planning to make an amendment yourself")
        end
      end
      expect(page).to have_content("The amendment has been successfully rejected")
    end
  end

  context "when amendments are not limited" do
    let(:limit_pending_amendments) { false }

    context "when proposal original locale is not the users locale" do
      let(:proposal) { create :proposal, users: [creator], component: component, title: { fr: "Proposal in french" } }

      it "Enforces the original locale" do
        click_link proposal.title["fr"]
        click_link "Amend"

        expect(page).not_to have_content("CREATE AMENDMENT DRAFT")
        expect(page).to have_content("CRÉER UN PROJET D'AMENDEMENT")
      end

      context "and not enforced" do
        let(:enforce_locale) { false }

        it "does not enforce the original locale" do
          click_link proposal.title["fr"]
          click_link "Amend"

          expect(page).to have_content("CREATE AMENDMENT DRAFT")
          expect(page).not_to have_content("CRÉER UN PROJET D'AMENDEMENT")
        end
      end

      context "and user has as preference the translated locale" do
        let(:logged_user) { create(:user, :confirmed, organization: organization, locale: "fr") }

        it "Enforces the original locale" do
          click_link proposal.title["fr"]
          click_link "Amend"

          expect(page).not_to have_content("CREATE AMENDMENT DRAFT")
          expect(page).to have_content("CRÉER UN PROJET D'AMENDEMENT")
        end
      end
    end

    it "can create a new one" do
      click_link proposal.title["en"]
      expect(page).to have_content(proposal.title["en"])
      expect(page).to have_content(emendation.title["en"])
      click_link "Amend"

      expect(page).not_to have_content("Currently, there's another amendment being evaluated for this proposal.")
      expect(page).not_to have_content(proposal.title["en"])
      expect(page).to have_content("CREATE AMENDMENT DRAFT")
    end

    context "when the author is logged" do
      let(:logged_user) { creator }

      it "can be accepted" do
        click_link proposal.title["en"]
        click_link "An emendation for the proposal"
        click_link "Accept"
        perform_enqueued_jobs do
          click_button "Accept amendment"
        end

        emails.each do |email|
          expect(email.subject).to have_content("Accepted amendment for")
          expect(email.text_part.to_s).not_to have_content("If you are planning to make an amendment yourself")
        end
        expect(page).to have_content("The amendment has been accepted successfully")
      end

      it "can be rejected" do
        click_link proposal.title["en"]
        click_link "An emendation for the proposal"
        perform_enqueued_jobs do
          click_link "Reject"
        end

        emails.each do |email|
          expect(email.subject).to have_content("Amendment rejected for")
          expect(email.text_part.to_s).not_to have_content("planning to make an amendment yourself")
        end
        expect(page).to have_content("The amendment has been successfully rejected")
      end
    end
  end
end
