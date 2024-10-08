# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::ViewModel.include(ApplicationHelper)
  # redirect registration if specified in secrets
  Decidim::Devise::RegistrationsController.include(RegistrationsControllerOverride)
  # block registration through Omniauth signin
  Decidim::Devise::OmniauthRegistrationsController.include(OmniauthRegistrationsControllerOverride)
  # redirect users to interest after acceptin an invitation
  Decidim::Devise::InvitationsController.include(InvitationsControllerOverride)

  # disables inviting external users if enabled
  Decidim::Meetings::Admin::InvitesController.include(InvitesControllerOverride)

  # makes "type" proposals in the filter the default
  Decidim::Proposals::ProposalsController.include(ProposalsControllerOverride)
  Decidim::Proposals::ApplicationHelper.include(Decidim::Proposals::ApplicationHelperOverride)
  # ensures same language is enforce on amendments to proposals
  Decidim::AmendmentsController.include(AmendmentsEnforceLocale)

  # sends notifications for answering surveys
  Decidim::Forms::AnswerQuestionnaire.include(AnswerQuestionnaireOverride)

  # Dates formatting
  Decidim::CardMetadataCell.include(CardMetadataCellOverride)
  # detect custom cards for leadership campaigns
  Decidim::CardHelper.include(CardHelperOverride)

  # more highlighted elements for leadership process
  Decidim::Proposals::HighlightedProposalsForComponentCell.include(HighlightedProposalsForComponentCellOverride)

  # change the default sorting for comments
  Decidim::Comments::CommentsCell.include(CommentsCellOverride)

  Decidim::Amendable::Accept.include(AmendableAcceptOverride)
  Decidim::Amendable::Reject.include(AmendableRejectOverride)
end
