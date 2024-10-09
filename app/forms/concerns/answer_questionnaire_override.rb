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

      with_events do
        answer_questionnaire
      end

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

      answers = form.responses_by_step.flatten.select(&:display_conditions_fulfilled?).to_h do |form_answer|
        body = if form_answer.choices.present?
                 form_answer.choices.map { |c| c.custom_body.present? ? "#{c.body} (#{c.custom_body})" : c.body }.join("<br>\n")
               else
                 form_answer.body.presence || "N/A"
               end
        [translated_attribute(form_answer.question.body), body]
      end

      emails.each do |email|
        QuestionnaireSubmitMailer.notify(current_organization, email, questionnaire, answers).deliver_later
      end
    end
  end
end
