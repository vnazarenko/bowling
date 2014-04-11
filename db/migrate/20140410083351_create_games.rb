class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status, null: false
      t.integer :current_player_id
      t.integer :current_frame_position, default: 1

      t.timestamps
    end
  end
end
