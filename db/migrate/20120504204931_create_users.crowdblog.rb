# This migration comes from crowdblog (originally 20120215232711)
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :is_publisher

      t.timestamps
    end
  end
end
