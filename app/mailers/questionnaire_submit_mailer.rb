# frozen_string_literal: true

class QuestionnaireSubmitMailer < Decidim::ApplicationMailer
  include Decidim::TranslatableAttributes

  def notify(organization, email, questionnaire, answers)
    @organization = organization
    @title = translated_attribute(questionnaire.title)
    @subject = I18n.t("gpc.emails.questionnaire_submit.subject", title: @title)
    @url = ::Decidim::EngineRouter.main_proxy(questionnaire.questionnaire_for.component).root_path
    @answers = answers

    mail(to: email, subject: @subject)
  end
end
