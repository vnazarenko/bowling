class CreateUserGameRelations < ActiveRecord::Migration
  def change
    create_table :user_game_relations do |t|
      t.integer :user_id, :game_id, null: :false
      t.integer :position, default: 1
      t.integer :total_score, default: 0

      t.timestamps
    end
  end
end
