# frozen_string_literal: true

require "rails_helper"

describe "Custom buttons" do
  let(:organization) { create(:organization) }
  let(:space) { create(:assembly, organization:) }
  let(:space_path) { decidim_assemblies.assembly_path(space) }
  let(:env) { :chat_button }
  let(:url) { "http://example.org" }

  before do
    allow(Rails.application.secrets).to receive(:dig).and_call_original
    allow(Rails.application.secrets).to receive(:dig).with(:gpc, env).and_return(url)
    switch_to_host(organization.host)
    visit space_path
  end

  shared_examples "handles the chat button" do
    let(:env) { :chat_button }
    it "has the chat button" do
      expect(page).to have_link("GREEN CHAT (beta)", href: url)
    end

    context "when no env var" do
      let(:env) { :another }

      it "does not have the chat button" do
        expect(page).not_to have_link("GREEN CHAT (beta)")
      end
    end

    context "when nil env var" do
      let(:url) { nil }

      it "does not have the chat button" do
        expect(page).not_to have_link("GREEN CHAT (beta)")
      end
    end
  end

  shared_examples "handles the donate button" do
    let(:env) { :donate_button }
    it "has the donate button" do
      expect(page).to have_link("Donate $10", href: url)
    end

    context "when no env var" do
      let(:env) { :another }

      it "does not have the donate button" do
        expect(page).not_to have_link("Donate $10")
      end
    end

    context "when nil env var" do
      let(:url) { nil }

      it "does not have the donate button" do
        expect(page).not_to have_link("Donate $10")
      end
    end
  end

  it_behaves_like "handles the chat button"
  it_behaves_like "handles the donate button"

  context "when participatory_process" do
    let(:space) { create(:participatory_process, organization:) }
    let(:space_path) { decidim_participatory_processes.participatory_process_path(space) }

    it_behaves_like "handles the chat button"
    it_behaves_like "handles the donate button"
  end

  context "when conference" do
    let(:space) { create(:conference, organization:) }
    let(:space_path) { decidim_conferences.conference_path(space) }

    it_behaves_like "handles the chat button"
  end
end
