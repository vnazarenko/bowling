class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.integer :user_game_relation_id
      t.integer :first_try_score, :second_try_score
      t.integer :position, default: 1

      t.timestamps
    end
  end
end
