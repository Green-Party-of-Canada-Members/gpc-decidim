# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module AnswerQuestionnaireOverride
  extend ActiveSupport::Concern
  include Decidim::TranslatableAttributes

  included do
    # Answers a questionnaire if it is valid
    #
    # Broadcasts :ok if successful, :invalid otherwise.
    def call
      return broadcast(:invalid) if @form.invalid? || user_already_answered?

      answer_questionnaire

      if @errors
        reset_form_attachments
        broadcast(:invalid)
      else
        send_notifications

        broadcast(:ok)
      end
    end

    private

    def send_notifications
      emails = Rails.application.secrets.dig(:gpc, :questionnaire_notify_emails)
      return if emails.blank?

      answers = form.responses_by_step.flatten.select(&:display_conditions_fulfilled?).map do |form_answer|
        [translated_attribute(form_answer.question.body), form_answer.body]
      end.to_h

      emails.each do |email|
        QuestionnaireSubmitMailer.notify(@current_user, email, questionnaire, answers).deliver_later
      end
    end
  end
end
