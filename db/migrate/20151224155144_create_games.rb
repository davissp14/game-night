class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_id
      t.string :title
      t.string :thumbnail
      t.string :url
      t.string :description
      t.decimal :rating
      t.timestamps null: false
    end

  end
end
