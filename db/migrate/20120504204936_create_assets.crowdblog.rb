# This migration comes from crowdblog (originally 20120219071614)
class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
    	t.integer :post_id
      t.string :attachment

      t.timestamps
    end
  end
end
