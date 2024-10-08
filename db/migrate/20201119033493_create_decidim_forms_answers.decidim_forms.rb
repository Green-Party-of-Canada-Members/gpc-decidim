# frozen_string_literal: true
# This migration comes from decidim_forms (originally 20170515144119)

class CreateDecidimFormsAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_forms_answers do |t|
      t.references :decidim_user, index: true
      t.references :decidim_questionnaire, index: true
      t.references :decidim_question, index: { name: "index_decidim_forms_answers_question_id" }
      t.text :body

      t.timestamps
    end
  end
end
