# frozen_string_literal: true

class QuestionnaireSubmitMailer < Decidim::ApplicationMailer
  include Decidim::TranslatableAttributes

  def notify(user, email, questionnaire, answers)
    @organization = user.organization
    @title = translated_attribute(questionnaire.title)
    @subject = I18n.t("gpc.emails.questionnaire_submit.subject", title: @title)
    @url = ::Decidim::EngineRouter.main_proxy(questionnaire.questionnaire_for.component).root_path
    @answers = answers

    with_user(user) do
      mail(to: email, subject: @subject)
    end
  end
end
