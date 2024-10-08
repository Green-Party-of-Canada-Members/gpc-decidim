# frozen_string_literal: true

require "rails_helper"

describe "Custom proposals fields", versioning: true do
  let(:organization) { create(:organization, enable_machine_translations: true, machine_translation_display_priority: "translation") }
  let(:participatory_process) do
    create(:participatory_process, :with_steps, organization:)
  end

  let(:component) do
    create(:proposal_component,
           participatory_space: participatory_process, settings:, step_settings:)
  end
  let(:active_step_id) { participatory_process.active_step.id }
  let(:step_settings) { { active_step_id => { amendment_creation_enabled:, amendments_visibility: visibility } } }
  let(:visibility) { "all" }
  let(:settings) { { amendments_enabled:, limit_pending_amendments: } }
  let(:creator) { create(:user, :confirmed, organization:) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:amender) { create(:user, :confirmed, organization:) }
  let(:follower) { create(:user, :confirmed, organization:) }
  let!(:follow) { create(:follow, user: follower, followable: proposal) }

  let!(:proposal) { create(:proposal, users: [creator], component:) }
  let!(:emendation) { create(:proposal, users: [amender], title: { en: "An emendation for the proposal" }, component:) }
  let!(:amendment) { create(:amendment, amendable: proposal, emendation:, state: amendment_state) }

  let(:amendment_state) { "evaluating" }
  let(:limit_pending_amendments) { true }
  let(:amendments_enabled) { true }
  let(:amendment_creation_enabled) { true }
  let(:logged_user) { user }
  let(:enforce_locale) { true }
  let(:gpc_conf) do
    {
      enforce_original_amendments_locale: enforce_locale
    }
  end

  before do
    allow(Rails.application.secrets).to receive(:gpc).and_return(gpc_conf)
    allow(Decidim).to receive(:machine_translation_service_klass).and_return(nil)
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
      click_on proposal.title["en"]
      expect(page).to have_content(proposal.title["en"])
      expect(page).to have_content(emendation.title["en"])
      click_on "Amend"

      within "#LimitAmendmentsModal" do
        expect(page).to have_link(href: amendment_path)
        expect(page).to have_content("Currently, there's another amendment being evaluated for this proposal.")
        expect(page).to have_content("You can also be notified when the current amendment is accepted or rejected")
      end
    end
  end

  context "when logged is the author" do
    let(:logged_user) { creator }

    it "can be accepted" do
      click_on proposal.title["en"]
      click_on "An emendation for the proposal"
      click_on "Accept"
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
      click_on proposal.title["en"]
      click_on "An emendation for the proposal"
      perform_enqueued_jobs do
        click_on "Reject"
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

    context "when proposal original locale is not the organization locale" do
      before do
        click_on "Proposal in french language"
        click_on "Amend"
      end

      let(:proposal) { create(:proposal, users: [creator], component:, title: { fr: "Proposition en langue française", machine_translations: { en: "Proposal in french language" } }) }

      it "Enforces the original locale" do
        expect(page).to have_content("This proposal was originally created in Français")
        expect(page).not_to have_content("Create Amendment Draft")
        expect(page).to have_content("Créer un projet d'amendement")
        expect(page).to have_field(with: "Proposition en langue française")
        expect(page).not_to have_field(with: "Proposal in french language")
      end

      context "and not enforced" do
        let(:enforce_locale) { false }

        it "does not enforce the original locale" do
          expect(page).not_to have_content("This proposal was originally created in Français")
          expect(page).to have_content("Create Amendment Draft")
          expect(page).not_to have_content("Créer un projet d'amendement")
          expect(page).not_to have_field(with: "Proposition en langue française")
          expect(page).to have_field(with: "Proposal in french language")
        end
      end

      context "and user has as preference the translated locale" do
        let(:user) { create(:user, :confirmed, organization:, locale: "en") }

        it "Enforces the original locale" do
          expect(page).to have_content("This proposal was originally created in Français")
          expect(page).not_to have_content("Create Amendment Draft")
          expect(page).to have_content("Créer un projet d'amendement")
          expect(page).to have_field(with: "Proposition en langue française")
          expect(page).not_to have_field(with: "Proposal in french language")
        end
      end
    end

    context "when proposal original locale is the organization locale" do
      let(:creator) { create(:user, :confirmed, organization:, locale: "fr") }
      let(:proposal) { create(:proposal, users: [creator], component:, title: { en: "Proposal in english language", machine_translations: { fr: "Proposition en langue anglaise" } }) }
      let(:amendment) { nil }
      let(:emendation) { nil }

      before do
        within_language_menu do
          click_on "Français"
        end

        click_on "Proposition en langue anglaise"
        click_on "Modifier"
      end

      it "Enforces the original locale" do
        expect(page).to have_content("Cette proposition a été initialement créée dans English")
        expect(page).to have_content("Create Amendment Draft")
        expect(page).not_to have_content("Créer un projet d'amendement")
        expect(page).to have_field(with: "Proposal in english language")
        expect(page).not_to have_field(with: "Proposition en langue anglaise")
        fill_in "Title", with: "New Proposal in english language"
        click_button "Create"
        expect(page).to have_content("Edit Amendment Draft")
      end

      context "and is an official proposal" do
        let(:proposal) { create(:proposal, :official, users: [creator], component:, title: { en: "Proposal in english language", machine_translations: { fr: "Proposition en langue anglaise" } }) }

        it "Does not enforce the original locale" do
          expect(page).not_to have_content("Cette proposition a été initialement créée dans English")
          expect(page).not_to have_content("Create Amendment Draft")
          expect(page).to have_content("Créer un projet d'amendement")
          expect(page).not_to have_field(with: "Proposal in english language")
          expect(page).to have_field(with: "Proposition en langue anglaise")
          fill_in "Titre", with: "Nouveau proposition en langue anglaise"
          click_button "Créer"
          expect(page).to have_content("Aucune modification similaire trouvé.")
        end
      end

      context "and not enforced" do
        let(:enforce_locale) { false }

        it "does not enforce the original locale" do
          expect(page).not_to have_content("Cette proposition a été initialement créée dans English")
          expect(page).not_to have_content("Create Amendment Draft")
          expect(page).to have_content("Créer un projet d'amendement")
          expect(page).not_to have_field(with: "Proposal in english language")
          expect(page).to have_field(with: "Proposition en langue anglaise")
        end
      end

      context "and user has as preference the translated locale" do
        let(:user) { create(:user, :confirmed, organization:, locale: "fr") }

        it "Enforces the original locale" do
          expect(page).to have_content("Cette proposition a été initialement créée dans English")
          expect(page).to have_content("Create Amendment Draft")
          expect(page).not_to have_content("Créer un projet d'amendement")
          expect(page).to have_field(with: "Proposal in english language")
          expect(page).not_to have_field(with: "Proposition en langue anglaise")
        end
      end
    end

    it "can create a new one" do
      click_on proposal.title["en"]
      expect(page).to have_content(proposal.title["en"])
      expect(page).to have_content(emendation.title["en"])
      click_on "Amend"

      expect(page).not_to have_content("Currently, there's another amendment being evaluated for this proposal.")
      expect(page).not_to have_content(proposal.title["en"])
      expect(page).to have_content("Create Amendment Draft")
    end

    context "when the author is logged" do
      let(:logged_user) { creator }

      it "can be accepted" do
        click_on proposal.title["en"]
        click_on "An emendation for the proposal"
        click_on "Accept"
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
        click_on proposal.title["en"]
        click_on "An emendation for the proposal"
        perform_enqueued_jobs do
          click_on "Reject"
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
