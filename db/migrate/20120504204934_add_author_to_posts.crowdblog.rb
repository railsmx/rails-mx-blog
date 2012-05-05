# This migration comes from crowdblog (originally 20120219014520)
class AddAuthorToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :author_id, :integer

  end
end
