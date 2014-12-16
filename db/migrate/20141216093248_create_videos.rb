class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :video_url
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :videos, :users
  end
end
