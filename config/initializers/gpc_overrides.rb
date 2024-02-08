# frozen_string_literal: true

Rails.application.config.to_prepare do
  # redirect registration if specified in secrets
  Decidim::Devise::RegistrationsController.include(RegistrationsControllerOverride)
  # block registration through Omniauth signin
  Decidim::Devise::OmniauthRegistrationsController.include(OmniauthRegistrationsControllerOverride)
  # redirect users to interest after acceptin an invitation
  Decidim::Devise::InvitationsController.include(InvitationsControllerOverride)

  # disables inviting external users if enabled
  Decidim::Meetings::Admin::InvitesController.include(InvitesControllerOverride)

  # ensures same language is enforce on amendments to proposals
  Decidim::AmendmentsController.include(AmendmentsEnforceLocale)

  # sends notifications for answering surveys
  Decidim::Forms::AnswerQuestionnaire.include(AnswerQuestionnaireOverride)

  # detect custom cards for leadership campaigns
  Decidim::CardHelper.include(CardHelperOverride)

  # more highlighted elements for leadership process
  Decidim::Proposals::HighlightedProposalsForComponentCell.include(HighlightedProposalsForComponentCellOverride)

  # change the default sorting for comments
  Decidim::Comments::CommentsCell.include(CommentsCellOverride)

  Decidim::Amendable::Accept.include(AmendableAcceptOverride)
  Decidim::Amendable::Reject.include(AmendableRejectOverride)
end
