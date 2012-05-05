# This migration comes from crowdblog (originally 20120219234253)
class AddAliasToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gravatar_alias, :string

  end
end
