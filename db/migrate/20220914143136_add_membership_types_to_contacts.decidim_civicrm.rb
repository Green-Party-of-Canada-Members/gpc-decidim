# This migration comes from decidim_civicrm (originally 20211126132120)
class AddMembershipTypesToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_civicrm_contacts, :membership_types, :jsonb
  end
end
