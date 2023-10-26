# frozen_string_literal: true

module CommentsCellOverride
  extend ActiveSupport::Concern

  included do
    private

    def order
      if options[:order]
        controller.send(:cookies)[:comment_order] = options[:order]
        options[:order]
      else
        controller.send(:cookies)[:comment_order] || "recent"
      end
    end
  end
end
