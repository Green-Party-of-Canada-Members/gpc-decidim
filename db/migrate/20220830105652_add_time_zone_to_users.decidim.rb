# frozen_string_literal: true
# This migration comes from decidim (originally 20220823094517)

class AddTimeZoneToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_users, :time_zone, :string
  end
end
