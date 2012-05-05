# This migration comes from crowdblog (originally 20120217213920)
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.boolean :published
      t.string :permalink
      t.date :published_at

      t.timestamps
    end
  end
end
