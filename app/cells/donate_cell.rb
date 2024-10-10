# frozen_string_literal: true

class DonateCell < Decidim::ViewModel
  def show
    render if generic_donate_url.present?
  end

  def button_class
    return options[:button_class] if options[:button_class].present?

    "button__lg"
  end

  def chat?
    options[:chat] == true
  end
end
